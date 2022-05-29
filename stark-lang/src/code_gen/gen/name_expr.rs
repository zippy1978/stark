use inkwell::values::BasicValueEnum;

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
        match &symbol.symbol_type.kind {
            crate::typing::TypeKind::Primary(_) => {
                Result::Ok(Some(context.builder.build_load(symbol.value, "load")))
            }
            crate::typing::TypeKind::Complex => todo!(),
            crate::typing::TypeKind::Function { args, returns } => {
                Result::Ok(Some(BasicValueEnum::PointerValue(
                    context
                        .module
                        .get_function(&name.node)
                        .unwrap()
                        .as_global_value()
                        .as_pointer_value(),
                )))
            }
        }
    }
}
