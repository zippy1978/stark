use crate::ast::{
    self, clone_args, clone_expr, clone_ident, Folder, Log, LogLevel, Logger, StmtKind,
};

use super::{
    SymbolError, SymbolScope, SymbolTable, Type, TypeCheckerError, TypeKind, TypeRegistry,
};

/// Result returned by type checker.
pub type TypeCheckerResult = Result<ast::Stmts, TypeCheckerError>;

/// Type checker context.
pub struct TypeCheckerContext<'ctx> {
    type_registry: &'ctx mut TypeRegistry,
    symbol_table: SymbolTable,
}

impl<'ctx> TypeCheckerContext<'ctx> {
    pub fn new(type_registry: &'ctx mut TypeRegistry) -> Self {
        TypeCheckerContext {
            type_registry,
            symbol_table: SymbolTable::new(),
        }
    }
}

/// Type checker.
/// Visits the AST to resolve expression types and enforce type rules.
pub struct TypeChecker {
    logger: Logger,
}

impl<'ctx> Folder<TypeCheckerContext<'ctx>> for TypeChecker {
    fn fold_expr(&mut self, expr: &ast::Expr, context: &mut TypeCheckerContext<'ctx>) -> ast::Expr {
        // Check and determine type
        match &expr.node {
            // Name
            ast::ExprKind::Name { id } => match context.symbol_table.lookup_symbol(&id.node) {
                Some(symbol) => {
                    clone_expr(expr).with_type_name(symbol.symbol_type.name.to_string())
                }
                None => {
                    self.logger.add(Log::new_with_single_label(
                        format!("symbol `{}` is undefined", &id.node),
                        LogLevel::Error,
                        id.location,
                    ));

                    clone_expr(expr)
                }
            },
            // Constant
            ast::ExprKind::Constant { value } => {
                let type_name = match value {
                    ast::Constant::Bool(_) => "bool",
                    ast::Constant::Str(_) => panic!("strings are not supported yet !"),
                    ast::Constant::Int(_) => "int",
                    ast::Constant::Float(_) => "float",
                };

                clone_expr(expr).with_type_name(type_name.to_string())
            }
        }
    }

    fn fold_var_decl(
        &mut self,
        name: &ast::Ident,
        var_type: &ast::Ident,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> StmtKind {
        // Check if type exists
        match context.type_registry.lookup_type(&var_type.node) {
            Some(ty) => {
                // Try to insert new symbol
                match context
                    .symbol_table
                    .insert(&name.node, ty.clone(), name.location)
                {
                    Ok(_) => (),
                    Err(err) => self.log_symbol_error(&err, name),
                }
            }
            None => self.log_unknown_type(var_type),
        };

        StmtKind::VarDecl {
            name: clone_ident(name).with_type_name(var_type.node.to_string()),
            var_type: clone_ident(var_type),
        }
    }

    fn fold_assign(
        &mut self,
        target: &ast::Expr,
        value: &ast::Expr,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> StmtKind {
        let folded_target = self.fold_expr(target, context);
        let folded_value = self.fold_expr(value, context);

        match &folded_value.info.type_name {
            Some(target_type_name) => match &folded_target.info.type_name {
                Some(value_type_name) => {
                    if target_type_name != value_type_name {
                        self.logger.add(Log::new_with_single_label(
                            format!(
                                "type mismatch, expected `{}`, found `{}`",
                                target_type_name, value_type_name
                            ),
                            LogLevel::Error,
                            value.location,
                        ));
                    }
                }
                None => {
                    self.logger.add(Log::new_with_single_label(
                        "unable to determine expression type",
                        LogLevel::Error,
                        value.location,
                    ));
                }
            },
            None => {
                self.logger.add(Log::new_with_single_label(
                    "unable to determine expression type",
                    LogLevel::Error,
                    value.location,
                ));
            }
        };

        StmtKind::Assign {
            target: Box::new(folded_target),
            value: Box::new(folded_value),
        }
    }

    fn fold_func_def(
        &mut self,
        name: &ast::Ident,
        args: &ast::Args,
        body: &ast::Stmts,
        returns: &Option<ast::Ident>,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> StmtKind {
        // Push scope
        context
            .symbol_table
            .push_scope(SymbolScope::new(super::SymbolScopeType::Function(
                name.node.to_string(),
            )));

        // Check arg types
        for arg in args {
            match context.type_registry.lookup_type(&arg.var_type.node) {
                Some(ty) => {
                    // Insert symbol
                    match context.symbol_table.insert(
                        &arg.name.node.clone(),
                        ty.clone(),
                        arg.name.location,
                    ) {
                        Ok(_) => (),
                        Err(err) => self.log_symbol_error(&err, &arg.name),
                    }
                }
                None => self.log_unknown_type(&arg.var_type),
            }
        }

        // Check return type
        match returns {
            Some(return_type) => match context.type_registry.lookup_type(&return_type.node) {
                Some(_) => (),
                None => self.log_unknown_type(&return_type),
            },
            None => (),
        }

        // Insert symbol
        match context.symbol_table.insert(
            &name.node,
            Type {
                name: name.node.to_string(),
                kind: TypeKind::Function {
                    args: args
                        .iter()
                        .map(|arg| arg.var_type.node.to_string())
                        .collect::<Vec<_>>(),
                    returns: match returns {
                        Some(return_type) => Some(return_type.node.to_string()),
                        None => None,
                    },
                },
                definition_location: Some(name.location),
            },
            name.location,
        ) {
            Ok(_) => (),
            Err(err) => self.log_symbol_error(&err, name),
        };

        // Fold body
        let folded_body = self.fold_stmts(body, context);

        // Check return instruction (last of body)
        if let Some(returns) = returns {
            match folded_body.last() {
                Some(last_stmt) => match &last_stmt.node {
                    StmtKind::Expr { value } =>  match &value.info.type_name {
                        Some(type_name) => {
                            if type_name != &returns.node {
                                self.logger.add(Log::new_with_single_label(
                                    format!(
                                        "type mismatch, expected `{}` return, found `{}`",
                                        returns.node, type_name
                                    ),
                                    LogLevel::Error,
                                    last_stmt.location,
                                ).with_label(format!("function `{}` return type is `{}`", &name.node, &returns.node), returns.location));
                            }
                        }
                        None => {
                            self.logger.add(Log::new_with_single_label(
                                "unable to determine expression type",
                                LogLevel::Error,
                                last_stmt.location,
                            ));
                        }
                    },
                    _ => {
                        self.logger.add(Log::new_with_single_label(
                            "function return is missing",
                            LogLevel::Error,
                            last_stmt.location,
                        ));
                    },
                },
                None => (),
            }
        };

        // Fold new node
        let new_func_def = StmtKind::FuncDef {
            name: clone_ident(name),
            args: Box::new(clone_args(args)),
            body: folded_body,
            returns: match returns {
                Some(ident) => Some(clone_ident(ident)),
                None => None,
            },
        };

        // Pop scope
        context.symbol_table.pop_scope();

        new_func_def
    }
}

impl<'ctx> TypeChecker {
    pub fn new() -> Self {
        TypeChecker {
            logger: Logger::new(),
        }
    }

    /// Performs type checking on an input AST.
    /// A new "typed" AST is outputted as result.
    pub fn check(
        &mut self,
        ast: &ast::Stmts,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> TypeCheckerResult {
        // Clear logs
        self.logger.clear();

        // Set initial (global) scope
        context
            .symbol_table
            .push_scope(super::SymbolScope::new(super::SymbolScopeType::Global));

        // Fold
        let typed_ast = self.fold_stmts(ast, context);
        if self.logger.has_error() {
            Result::Err(TypeCheckerError {
                logs: self.logger.logs(),
            })
        } else {
            Result::Ok(typed_ast)
        }
    }

    fn log_unknown_type(&mut self, ident: &ast::Ident) {
        self.logger.add(Log::new_with_single_label(
            format!("unknown type `{}`", &ident.node),
            LogLevel::Error,
            ident.location,
        ));
    }

    fn log_symbol_error(&mut self, error: &SymbolError, name: &ast::Ident) {
        match error {
            // Symbol is already defined
            SymbolError::AlreadyDefined(symbol) => {
                self.logger.add(
                    Log::new(
                        format!("`{}` is already defined", &name.node),
                        LogLevel::Error,
                    )
                    .with_label(
                        format!("`{}` was previously defined here ", &name.node),
                        symbol.definition_location,
                    )
                    .with_label(
                        format!("`{}` is redefined here ", &name.node),
                        name.location,
                    ),
                );
            }
            // Symbol is already defined in upper scope
            SymbolError::AlreadyDefinedInUpperScope(symbol) => {
                self.logger.add(
                    Log::new(
                        format!("`{}` is already defined", &name.node),
                        LogLevel::Error,
                    )
                    .with_label(
                        format!(
                            "`{}` was previously defined in upper scope here ",
                            &name.node
                        ),
                        symbol.definition_location,
                    )
                    .with_label(
                        format!("`{}` is redefined here ", &name.node),
                        name.location,
                    ),
                );
            }
            // Scope error
            SymbolError::NoScope => {
                self.logger.add(Log::new_with_single_label(
                    "scope error",
                    LogLevel::Error,
                    name.location,
                ));
            }
        };
    }
}
