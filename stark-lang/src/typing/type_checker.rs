use crate::ast::{self, Location, Log, LogLevel, Logger, Visitor};

use super::{Type, TypeCheckError, TypeCheckerError, TypeRegistry};

/// Result returned while visiting AST.
type TypeCheckResult = Result<Option<Type>, TypeCheckError>;

/// Result returned by type checker.
pub type TypeCheckerResult = Result<(), TypeCheckerError>;

/// Type checker context.
pub struct TypeCheckerContext<'a> {
    type_registry: &'a mut TypeRegistry,
}

impl<'a> TypeCheckerContext<'a> {
    pub fn new(type_registry: &'a mut TypeRegistry) -> Self {
        TypeCheckerContext { type_registry }
    }
}

/// Type checker.
/// Visits the AST to resolve expression types and enforce type rules.
pub struct TypeChecker {
    logger: Logger,
}

impl<'a> Visitor<TypeCheckResult, &mut TypeCheckerContext<'a>> for TypeChecker {
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
            ast::ExprKind::Mock { m } => todo!(),
            ast::ExprKind::Name { id } => todo!(),
            ast::ExprKind::Constant { value } => todo!(),
        }
    }
}

impl TypeChecker {
    pub fn new() -> Self {
        TypeChecker {
            logger: Logger::new(),
        }
    }

    pub fn check(
        &mut self,
        ast: &ast::Stmts,
        context: &mut TypeCheckerContext,
    ) -> TypeCheckerResult {
        self.logger.clear();

        // Add builtin types
        context
            .type_registry
            .insert("int", super::TypeKind::Primary, None);

        match self.visit_stmts(ast, context) {
            Ok(_) => Result::Ok(()),
            Err(_) => Result::Err(TypeCheckerError {
                logs: self.logger.logs(),
            }),
        }
    }

    fn check_var_decl(
        &mut self,
        name: &ast::Ident,
        var_type: &ast::Ident,
        context: &mut TypeCheckerContext,
    ) -> TypeCheckResult {
        // Check if type exists
        match context.type_registry.lookup_type(&var_type.node) {
            Some(ty) => {
                // Check that variable was not already defined
                // Or define it !
                // TODO
                Result::Ok(None)
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
    }
}
