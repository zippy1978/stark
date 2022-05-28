use crate::{
    ast,
    code_gen::{CodeGenContext, CodeGenerator, VisitorResult},
};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_name_expr(
        &mut self,
        name: &ast::Ident,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        let symbol = context.symbol_table.lookup_symbol(&name.node).unwrap();
        Result::Ok(Some(context.builder.build_load(symbol.value, &name.node)))
    }
}
