use super::{Args, Expr, Ident, Stmt, StmtKind, Stmts};

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
        }
    }
    fn visit_expr(&mut self, expr: &Expr, context: &mut C) -> R;

    fn visit_var_decl(&mut self, name: &Ident, var_type: &Ident, _context: &mut C) -> R;

    fn visit_assign(&mut self, target: &Expr, value: &Expr, context: &mut C) -> R;

    fn visit_func_def(
        &mut self,
        name: &Ident,
        args: &Args,
        body: &Stmts,
        returns: &Option<Ident>,
        context: &mut C,
    ) -> R;
}
