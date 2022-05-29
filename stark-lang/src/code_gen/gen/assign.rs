use crate::{
    ast::{self, Visitor},
    code_gen::{CodeGenContext, CodeGenerator, VisitorResult},
};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_assign(
        &mut self,
        target: &ast::Ident,
        value: &ast::Expr,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        let symbol = context.symbol_table.lookup_symbol(&target.node).unwrap();
        let symbol_pointer_value = symbol.value.clone();
        let visited_value = self.visit_expr(value, context).unwrap().unwrap();
        context
            .builder
            .build_store(symbol_pointer_value,  visited_value);

        Result::Ok(None)
    }
}
