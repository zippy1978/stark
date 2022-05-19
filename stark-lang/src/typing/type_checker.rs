use crate::ast::{
    self, clone_expr, clone_expr_with_context, clone_ident, Folder,
    Log, LogLevel, Logger, StmtKind,
};

use super::{SymbolError, SymbolTable, TypeCheckerError, TypeRegistry};

/// Result returned by type checker.
pub type TypeCheckerResult = Result<ast::Stmts<TypeInfo>, TypeCheckerError>;

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
#[derive(Debug, PartialEq)]
pub struct TypeInfo {
    pub type_name: Option<String>,
}

impl Clone for TypeInfo {
    fn clone(&self) -> Self {
        Self {
            type_name: self.type_name.clone(),
        }
    }
}

/// Type checker.
/// Visits the AST to resolve expression types and enforce type rules.
pub struct TypeChecker {
    logger: Logger,
}

impl<'ctx> Folder<TypeInfo, TypeCheckerContext<'ctx>> for TypeChecker {
    fn fold_expr(
        &mut self,
        expr: &ast::Expr,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::StmtKind<TypeInfo> {
        // Check and determine type
        match &expr.node {
            // Name
            ast::ExprKind::Name { id } => match context.symbol_table.lookup_symbol(&id.node) {
                Some(symbol) => {
                    let type_name = Some(symbol.symbol_type.name.to_string());
                    StmtKind::Expr {
                        value: Box::new(clone_expr_with_context(expr, TypeInfo { type_name })),
                    }
                }
                None => {
                    self.logger.add(Log::new_with_single_label(
                        format!("symbol `{}` is undefined", &id.node),
                        LogLevel::Error,
                        id.location,
                    ));

                    StmtKind::Expr {
                        value: Box::new(clone_expr(expr)),
                    }
                }
            },
            // Constant
            ast::ExprKind::Constant { value } => {
                let type_name = match value {
                    ast::Constant::Bool(_) => Some(
                        context
                            .type_registry
                            .lookup_type("bool")
                            .unwrap()
                            .name
                            .to_string(),
                    ),
                    ast::Constant::Str(_) => Some(
                        context
                            .type_registry
                            .lookup_type("string")
                            .unwrap()
                            .name
                            .to_string(),
                    ),
                    ast::Constant::Int(_) => Some(
                        context
                            .type_registry
                            .lookup_type("int")
                            .unwrap()
                            .name
                            .to_string(),
                    ),
                    ast::Constant::Float(_) => Some(
                        context
                            .type_registry
                            .lookup_type("float")
                            .unwrap()
                            .name
                            .to_string(),
                    ),
                };

                StmtKind::Expr {
                    value: Box::new(clone_expr_with_context(expr, TypeInfo { type_name })),
                }
            }
        }
    }

    fn fold_var_decl(
        &mut self,
        name: &ast::Ident,
        var_type: &ast::Ident,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> StmtKind<TypeInfo> {
        // Check if type exists
        match context.type_registry.lookup_type(&var_type.node) {
            Some(ty) => {
                // Try to insert new symbol
                match context
                    .symbol_table
                    .insert(&name.node, ty.clone(), name.location)
                {
                    Ok(_) => (),
                    Err(err) => match err {
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
                    },
                }
            }
            None => {
                self.logger.add(Log::new_with_single_label(
                    format!("unknown type `{}`", &var_type.node),
                    LogLevel::Error,
                    var_type.location,
                ));
            }
        };

        StmtKind::VarDecl {
            name: clone_ident(name),
            var_type: clone_ident(var_type),
        }
    }
}

/*
impl<'ctx> Visitor<TypeCheckResult, &mut TypeCheckerContext<'ctx>> for TypeChecker {
    fn visit_stmts(
        &mut self,
        stmts: &ast::Stmts,
        context: &mut TypeCheckerContext,
    ) -> TypeCheckResult {
        for stmt in stmts {
            match self.visit_stmt(stmt, context) {
                Ok(_) => continue,
                Err(err) => {
                    return Result::Err(err);
                }
            }
        }

        Result::Ok(None)
    }

    fn visit_stmt(
        &mut self,
        stmt: &ast::Stmt,
        context: &mut TypeCheckerContext,
    ) -> TypeCheckResult {
        match &stmt.node {
            ast::StmtKind::Expr { value } => self.visit_expr(value, context),
            ast::StmtKind::VarDecl { name, var_type } => {
                self.check_var_decl(name, var_type, context)
            }
            ast::StmtKind::Assign { target, value } => self.check_assign(target, value, context),
            ast::StmtKind::FuncDef {
                name,
                args,
                body,
                returns,
            } => self.check_func_def(name, args, body, returns, context),
        }
    }

    fn visit_expr(
        &mut self,
        expr: &ast::Expr,
        context: &mut TypeCheckerContext,
    ) -> TypeCheckResult {
        match &expr.node {
            ast::ExprKind::Name { id } => match context.symbol_table.lookup_symbol(&id.node) {
                Some(symbol) => Result::Ok(Some(symbol.symbol_type.clone())),
                None => Result::Err(TypeCheckError::SymbolNotFound(id.node.clone())),
            },
            ast::ExprKind::Constant { value } => match value {
                ast::Constant::Bool(_) => Result::Ok(Some(
                    context.type_registry.lookup_type("bool").unwrap().clone(),
                )),
                ast::Constant::Str(_) => Result::Ok(Some(
                    context.type_registry.lookup_type("string").unwrap().clone(),
                )),
                ast::Constant::Int(_) => Result::Ok(Some(
                    context.type_registry.lookup_type("string").unwrap().clone(),
                )),
                ast::Constant::Float(_) => Result::Ok(Some(
                    context.type_registry.lookup_type("float").unwrap().clone(),
                )),
            },
        }
    }
}*/

impl<'ctx> TypeChecker {
    pub fn new() -> Self {
        TypeChecker {
            logger: Logger::new(),
        }
    }

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

    /*
    /// Checks variable declaration.
    fn check_var_decl(
        &mut self,
        name: &ast::Ident,
        var_type: &ast::Ident,
        context: &mut TypeCheckerContext,
    ) -> TypeCheckResult {
        // Check if type exists
        match context.type_registry.lookup_type(&var_type.node) {
            Some(ty) => {
                // Try to insert new symbol
                match context
                    .symbol_table
                    .insert(&name.node, ty.clone(), name.location)
                {
                    Ok(_) => Result::Ok(None),
                    Err(err) => match err {
                        // Symbol is already defined
                        super::SymbolError::AlreadyDefined(symbol) => {
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
                            Result::Err(TypeCheckError::SymbolAlreadyDeclared(
                                name.node.to_string(),
                            ))
                        }
                        // Symbol is already defined in upper scope
                        super::SymbolError::AlreadyDefinedInUpperScope(symbol) => {
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
                            Result::Err(TypeCheckError::SymbolAlreadyDeclared(
                                name.node.to_string(),
                            ))
                        }
                        // Scope error
                        super::SymbolError::NoScope => Result::Err(TypeCheckError::Scope),
                    },
                }
            }
            None => {
                self.logger.add(Log::new_with_single_label(
                    format!("unknown type `{}`", &var_type.node),
                    LogLevel::Error,
                    var_type.location,
                ));
                Result::Err(TypeCheckError::UnknownType(var_type.node.to_string()))
            }
        }
    }

    fn check_assign(
        &mut self,
        target: &ast::Expr,
        value: &ast::Expr,
        context: &mut TypeCheckerContext,
    ) -> TypeCheckResult {
        Result::Ok(None)
    }

    fn check_func_def(
        &mut self,
        name: &ast::Ident,
        args: &ast::Args,
        body: &ast::Stmts,
        returns: &Option<ast::Ident>,
        context: &mut TypeCheckerContext,
    ) -> TypeCheckResult {
        Result::Ok(None)
    }*/
}
