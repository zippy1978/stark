use super::{Stmt, Expr, Stmts};


/// Visitor. used to traverse an AST and collecting results.
/// But cannot modify it.
/// Consider using a [`Folder`] if mutation of the AST is required.
pub trait Visitor<R = (), C = ()> {
    // TODO : add default implementation to functions !
    fn visit_stmts(&mut self, stmts: &Stmts, context:C) -> R;
    fn visit_stmt(&mut self, stmt: &Stmt, context: C) -> R;
    fn visit_expr(&mut self, expr: &Expr, context: C) -> R;
}
