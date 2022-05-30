use crate::ast::{self, Folder, Log, LogLevel, Logger, StmtKind};

use super::{SymbolError, SymbolTable, TypeCheckerError, TypeRegistry};

/// Result returned by type checker.
pub type TypeCheckerResult = Result<ast::Stmts, TypeCheckerError>;

/// Type checker context.
pub struct TypeCheckerContext<'ctx> {
    pub(crate) type_registry: &'ctx mut TypeRegistry,
    pub(crate) symbol_table: SymbolTable,
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
    pub(crate) logger: Logger,
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

    pub(crate) fn log_undetermined_expression_type(&mut self, expr: &ast::Expr) {
        self.logger.add(Log::new_with_single_label(
            "unable to determine expression type",
            LogLevel::Error,
            expr.location,
        ))
    }

    pub(crate) fn log_unknown_type(&mut self, ident: &ast::Ident) {
        self.logger.add(Log::new_with_single_label(
            format!("unknown type `{}`", &ident.node),
            LogLevel::Error,
            ident.location,
        ));
    }

    pub(crate) fn log_undefined_symbol(&mut self, ident: &ast::Ident) {
        self.logger.add(Log::new_with_single_label(
            format!("symbol `{}` is undefined", &ident.node),
            LogLevel::Error,
            ident.location,
        ));
    }

    pub(crate) fn log_symbol_error(&mut self, error: &SymbolError<()>, name: &ast::Ident) {
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


impl<'ctx> Folder<TypeCheckerContext<'ctx>> for TypeChecker {
    fn fold_expr(&mut self, expr: &ast::Expr, context: &mut TypeCheckerContext<'ctx>) -> ast::Expr {
        match &expr.node {
            ast::ExprKind::Name { id } => self.handle_fold_name_expr(expr, id, context),
            ast::ExprKind::Constant { value } => self.handle_fold_contant_expr(expr, value, context),
            ast::ExprKind::Call { id, params } => self.handle_fold_call_expr(expr, id, params, context),
        }
    }

    fn fold_var_decl(
        &mut self,
        name: &ast::Ident,
        var_type: &ast::Ident,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> StmtKind {
        self.handle_fold_var_decl(name, var_type, context)
    }

    fn fold_assign(
        &mut self,
        target: &ast::Ident,
        value: &ast::Expr,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> StmtKind {
        self.handle_fold_assign(target, value, context)
    }

    fn fold_func_def(
        &mut self,
        name: &ast::Ident,
        args: &ast::Args,
        body: &ast::Stmts,
        returns: &Option<ast::Ident>,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> StmtKind {
        self.handle_fold_func_def(name, args, body, returns, context)
    }
}