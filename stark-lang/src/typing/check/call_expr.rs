use crate::{typing::{TypeChecker, TypeCheckerContext}, ast};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_fold_call_expr(
        &mut self,
        id: &ast::Ident,
        params: &ast::Params,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::Expr {
        todo!()
    }
}