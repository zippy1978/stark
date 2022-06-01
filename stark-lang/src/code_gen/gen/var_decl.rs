use crate::{
    ast::{self},
    code_gen::{resolve_llvm_type, CodeGenContext, CodeGenerator, VisitorResult},
};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_var_decl(
        &mut self,
        name: &ast::Ident,
        var_type: &ast::Ident,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        let ty = context.type_registry.lookup_type(&var_type.node).unwrap();

        if let Some(basic_type) = resolve_llvm_type(&ty.name, context) {
            let value = context.builder.build_alloca(basic_type, &name.node);
            context
                .symbol_table
                .insert(&name.node, ty.clone(), name.location.clone(), value)
                .unwrap();
        }

        Result::Ok(None)
    }
}
