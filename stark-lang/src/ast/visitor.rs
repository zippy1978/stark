use super::{Stmt, Expr, Stmts};

pub trait Visitor<R = (), C = ()> {
    fn visit_stmts(&mut self, stmts: &Stmts, context:C) -> R;
    fn visit_stmt(&mut self, stmt: &Stmt, context: C) -> R;
    fn visit_expr(&mut self, expr: &Expr, context: C) -> R;
}
