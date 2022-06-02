use crate::{
    ast,
    code_gen::{resolve_llvm_type, CodeGenContext, CodeGenerator, VisitorResult},
    typing::{SymbolScope, SymbolScopeType},
};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_func_def(
        &mut self,
        name: &ast::Ident,
        args: &ast::Args,
        body: &ast::Stmts,
        _returns: &Option<ast::Ident>,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {

        let mangled_function_name = context
        .mangler
        .mangle_function_name(context.symbol_table.current_module_name(), &name.node);
        let function = context.module.get_function(&mangled_function_name).unwrap();

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
