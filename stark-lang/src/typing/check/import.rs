use crate::{
    ast::{self},
    typing::{TypeChecker, TypeCheckerContext},
};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_fold_import(
        &mut self,
        name: &ast::Ident,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::StmtKind {
        todo!()
    }
}
