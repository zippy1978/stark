use crate::ast::{self, Visitor};

use super::Context;

pub struct Generator {
    context: Context,
}

impl Generator {
    pub fn new() -> Self {
        Generator {
            context: Context {},
        }
    }

    pub fn generate(&mut self, unit: &ast::Unit) {
        self.visit_unit(unit);
    }
}

impl Visitor for Generator {
    fn visit_unit(&mut self, unit: &ast::Unit) {
        let unit_iter = unit.iter();
        for s in unit_iter {
            self.visit_stmt(s);
        }
    }

    fn visit_stmt(&mut self, stmt: &ast::Stmt) {
        match &stmt.node {
            ast::StmtKind::Expr { value } => self.visit_expr(&value),
            ast::StmtKind::Declaration { variable, var_type } => println!("declaration {} : {}", variable, var_type),
            ast::StmtKind::Assign => todo!(),
        }
    }

    fn visit_expr(&mut self, expr: &ast::Expr) {
        match &expr.node {
            ast::ExprKind::Mock { m } => todo!(),
            ast::ExprKind::Name { id } => println!("{:?}", id),
            ast::ExprKind::Constant { value } => println!("{:?}", value),
        }
    }
}
