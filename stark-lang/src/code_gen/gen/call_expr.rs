use inkwell::values::BasicMetadataValueEnum;

use crate::{
    ast::{self, Visitor},
    code_gen::{CodeGenContext, CodeGenerator, VisitorResult},
    typing::TypeKind,
};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_call_expr(
        &mut self,
        id: &ast::Ident,
        params: &ast::Params,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        // Build parameters
        let mut llvm_params = Vec::<BasicMetadataValueEnum>::new();
        for param in params {
            let expr_value = self.visit_expr(param, context).unwrap().unwrap();
            llvm_params.push(expr_value.into());
        }

        let symbol = context.symbol_table.lookup_symbol(&id.node).unwrap();

        match &symbol.symbol_type.kind {
            // Function is callable
            TypeKind::Function {
                args: _,
                returns: _,
            } => {
                
                let mangled_function_name = context.mangler.mangle_function_name_from_dotted_name(
                    context.symbol_table.current_module_name(),
                    &id.node,
                );
                let function = context.module.get_function(&mangled_function_name).unwrap();

                let call_value = context
                    .builder
                    .build_call(function, &llvm_params[..], "call")
                    .try_as_basic_value();

                if call_value.is_left() {
                    Result::Ok(Some(call_value.unwrap_left()))
                } else {
                    Result::Ok(None)
                }
            }
            // Not the rest
            _ => panic!(),
        }
    }
}
