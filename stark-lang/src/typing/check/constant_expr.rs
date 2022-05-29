use crate::{
    ast::{self, clone_expr},
    typing::{TypeChecker, TypeCheckerContext},
};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_fold_contant_expr(
        &mut self,
        expr: &ast::Expr,
        value: &ast::Constant,
        _context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::Expr {
        let type_name = match value {
            ast::Constant::Bool(_) => "bool",
            ast::Constant::Str(_) => panic!("strings are not supported yet !"),
            ast::Constant::Int(_) => "int",
            ast::Constant::Float(_) => "float",
        };

        clone_expr(expr).with_type_name(type_name.to_string())
    }
}
