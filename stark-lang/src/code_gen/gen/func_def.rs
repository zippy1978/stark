use inkwell::types::{BasicMetadataTypeEnum, BasicType};

use crate::{
    ast,
    code_gen::{resolve_llvm_type, CodeGenContext, CodeGenerator, VisitorResult},
    typing::{SymbolScope, SymbolScopeType, Type, TypeKind},
};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_func_def(
        &mut self,
        name: &ast::Ident,
        args: &ast::Args,
        body: &ast::Stmts,
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

        let function = context.module.add_function(&name.node, fn_type, None);

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

        // Push scope
        context
            .symbol_table
            .push_scope(SymbolScope::new(SymbolScopeType::Function(
                name.node.to_string(),
            )));

        // Generate body
        let basic_block = context.llvm_context.append_basic_block(function, "entry");

        context.builder.position_at_end(basic_block);

        // Insert arguments on symbol table
        for (i, arg) in args.iter().enumerate() {
            let ty = context
                .type_registry
                .lookup_type(&arg.var_type.node)
                .unwrap();

            if let Some(basic_type) = resolve_llvm_type(&ty.name, context) {
                let value = context.builder.build_alloca(basic_type, &name.node);
                context
                    .symbol_table
                    .insert(&arg.name.node, ty.clone(), arg.name.location.clone(), value)
                    .unwrap();
                context.builder.build_store(
                    value,
                    function.get_nth_param(i.try_into().unwrap()).unwrap(),
                );
            };
        }

        // Visit body
        match self.handle_visit_stmts(body, context) {
            Ok(result) => match result {
                Some(value) => context.builder.build_return(Some(&value)),
                None => context.builder.build_return(None),
            },
            Err(err) => {
                return Result::Err(err);
            }
        };

        // Pop scope
        context.symbol_table.pop_scope();

        Result::Ok(None)
    }
}
