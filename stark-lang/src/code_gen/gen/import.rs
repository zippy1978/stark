use crate::{
    ast::{self},
    code_gen::{CodeGenContext, CodeGenerator, VisitorResult},
};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_import(
        &mut self,
        name: &ast::Ident,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        todo!()
    }
}
