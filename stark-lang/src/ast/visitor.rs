use super::{Stmt, Expr, Unit};

pub trait Visitor<R = ()> {
    fn visit_unit(&mut self, unit: &Unit) -> R;
    fn visit_stmt(&mut self, stmt: &Stmt) -> R;
    fn visit_expr(&mut self, expr: &Expr) -> R;
}
