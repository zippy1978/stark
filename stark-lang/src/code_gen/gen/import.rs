use crate::{
    ast::{self, Visitor},
    code_gen::{CodeGenContext, CodeGenerator, VisitorResult},
    typing::SymbolScope,
};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_import(
        &mut self,
        name: &ast::Ident,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        // Push module scope in order to mangle function delcaration with the module context
        context
            .symbol_table
            .push_scope(SymbolScope::new(crate::typing::SymbolScopeType::Module(
                name.node.to_string(),
            )));

        // Process module declarations
        let import_decl = context
            .module_map
            .build_import_declarations(&name.node)
            .unwrap();
        for decl in import_decl {
            match decl.node {
                ast::StmtKind::FuncDecl {
                    name,
                    args,
                    returns,
                } => {
                    self.visit_func_decl(&name, &args, &returns, context)
                        .unwrap();
                }
                _ => (),
            };
        }

        // Need to bring back module scope symbols to global scope
        // 1. copy and rename (with module prefix) generated symbols
        let module_symbols = context
            .symbol_table
            .clone_current_scope_symbols_with_prefix(format!("{}.", name.node).as_str());

        // 2. pop module scope
        context.symbol_table.pop_scope();

        // 3. bring module symbols on globals cope
        context.symbol_table.insert_all(module_symbols).unwrap();


        Result::Ok(None)
    }
}
