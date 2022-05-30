use crate::{
    ast::{self, clone_expr},
    typing::{TypeChecker, TypeCheckerContext},
};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_fold_name_expr(
        &mut self,
        expr: &ast::Expr,
        id: &ast::Ident,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::Expr {
        match context.symbol_table.lookup_symbol(&id.node) {
            Some(symbol) => clone_expr(expr).with_type_name(symbol.symbol_type.name.to_string()),
            None => {
                self.log_undefined_symbol(id);

                clone_expr(expr)
            }
        }
    }
}
