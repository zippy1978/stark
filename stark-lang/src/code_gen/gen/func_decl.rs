use inkwell::{types::{BasicMetadataTypeEnum, BasicType}, module::Linkage};

use crate::{
    ast,
    code_gen::{resolve_llvm_type, CodeGenContext, CodeGenerator, VisitorResult},
    typing::{Type, TypeKind},
};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_func_decl(
        &mut self,
        name: &ast::Ident,
        args: &ast::Args,
        returns: &Option<ast::Ident>,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {

        // Arguments
        let llvm_args = args
            .iter()
            .map(|a| resolve_llvm_type(&a.var_type.node, context).unwrap().into())
            .collect::<Vec<BasicMetadataTypeEnum>>();

        // Function type
        let fn_type = match returns {
            Some(returns) => resolve_llvm_type(&returns.node, context)
                .unwrap()
                .fn_type(&llvm_args[..], false),
            None => context
                .llvm_context
                .void_type()
                .fn_type(&llvm_args[..], false),
        };

        let mangled_function_name = context
            .mangler
            .mangle_function_name(context.symbol_table.current_module_name(), &name.node);
        let function = context.module.add_function(&mangled_function_name, fn_type, Some(Linkage::External));

        // Add function to symbol table
        context
            .symbol_table
            .insert(
                &name.node,
                Type {
                    name: name.node.to_string(),
                    kind: TypeKind::Function {
                        args: args
                            .iter()
                            .map(|arg| arg.var_type.node.to_string())
                            .collect::<Vec<_>>(),
                        returns: match returns {
                            Some(return_type) => Some(return_type.node.to_string()),
                            None => None,
                        },
                    },
                    definition_location: Some(name.location.clone()),
                },
                name.location.clone(),
                function.as_global_value().as_pointer_value(),
            )
            .unwrap();

        Result::Ok(None)
    }
}
