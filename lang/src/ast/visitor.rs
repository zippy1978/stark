use super::{Stmt, Expr, Unit};

pub trait Visitor {
    fn visit_unit(&mut self, unit: &Unit);
    fn visit_stmt(&mut self, stmt: &Stmt);
    fn visit_expr(&mut self, expr: &Expr);
}
