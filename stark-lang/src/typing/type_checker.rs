use crate::ast::{self, clone_expr, clone_ident, Folder, Log, LogLevel, Logger, StmtKind};

use super::{SymbolError, SymbolTable, TypeCheckerError, TypeRegistry};

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
    fn fold_expr(
        &mut self,
        expr: &ast::Expr,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::Expr {
        // Check and determine type
        match &expr.node {
            // Name
            ast::ExprKind::Name { id } => match context.symbol_table.lookup_symbol(&id.node) {
                Some(symbol) => clone_expr(expr).with_type_name(symbol.symbol_type.name.to_string()),
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
}
