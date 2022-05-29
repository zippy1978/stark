use crate::{
    ast,
    code_gen::{CodeGenContext, CodeGenerator, VisitorResult},
};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_call_expr(
        &mut self,
        id: &ast::Ident,
        params: &ast::Params,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        todo!()
    }
}
