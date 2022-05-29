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
            crate::typing::TypeKind::Function { args: _, returns: _ } => {
                // For functions return a function pointer (stored as value in symbol table)
                Result::Ok(Some(BasicValueEnum::PointerValue(symbol.value)))
            }
        }
    }
}
