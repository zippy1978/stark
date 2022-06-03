use super::{Args, Constant, Expr, Ident, Params, Stmt, StmtKind, Stmts};

/// Visitor. used to traverse an AST and collecting results.
/// But cannot modify it.
/// Consider using a [`super::Folder`] if mutation of the AST is required.
pub trait Visitor<R = (), C = ()> {
    fn visit_stmts(&mut self, stmts: &Stmts, context: &mut C) -> R;
    fn visit_stmt(&mut self, stmt: &Stmt, context: &mut C) -> R {
        match &stmt.node {
            StmtKind::Expr { value } => self.visit_expr(&value, context),
            StmtKind::VarDecl { name, var_type } => self.visit_var_decl(name, var_type, context),
            StmtKind::Assign { target, value } => self.visit_assign(&target, &value, context),
            StmtKind::FuncDef {
                name,
                args,
                body,
                returns,
            } => self.visit_func_def(name, args, body, returns, context),
            StmtKind::Import { name } => self.visit_import(name, context),
            StmtKind::Module { name, stmts } => self.visit_module(name, stmts, context),
        }
    }
    fn visit_expr(&mut self, expr: &Expr, context: &mut C) -> R {
        match &expr.node {
            super::ExprKind::Name { id } => self.visit_name_expr(id, context),
            super::ExprKind::Constant { value } => self.visit_constant_expr(value, context),
            super::ExprKind::Call { id, params } => self.visit_call_expr(id, params, context),
        }
    }

    fn visit_call_expr(&mut self, id: &Ident, params: &Params, context: &mut C) -> R;

    fn visit_name_expr(&mut self, name: &Ident, context: &mut C) -> R;

    fn visit_constant_expr(&mut self, constant: &Constant, context: &mut C) -> R;

    fn visit_var_decl(&mut self, name: &Ident, var_type: &Ident, _context: &mut C) -> R;

    fn visit_import(&mut self, name: &Ident, _context: &mut C) -> R;

    fn visit_module(&mut self, name: &Ident, stmts: &Stmts, _context: &mut C) -> R;

    fn visit_assign(&mut self, target: &Ident, value: &Expr, context: &mut C) -> R;

    fn visit_func_def(
        &mut self,
        name: &Ident,
        args: &Args,
        body: &Stmts,
        returns: &Option<Ident>,
        context: &mut C,
    ) -> R;
}
