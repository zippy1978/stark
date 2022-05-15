use super::{Stmt, Expr, Stmts};

pub trait Visitor<R = ()> {
    fn visit_stmts(&mut self, stmts: &Stmts) -> R;
    fn visit_stmt(&mut self, stmt: &Stmt) -> R;
    fn visit_expr(&mut self, expr: &Expr) -> R;
}
