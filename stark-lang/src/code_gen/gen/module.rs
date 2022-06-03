use crate::{
    ast::{self, Visitor},
    code_gen::{CodeGenContext, CodeGenerator, VisitorResult},
    typing::{SymbolScope, SymbolScopeType},
};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_module(
        &mut self,
        name: &ast::Ident,
        stmts: &ast::Stmts,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        // Push module scope
        context
            .symbol_table
            .push_scope(SymbolScope::new(SymbolScopeType::Module(
                name.node.to_string(),
            )));

        // Declare globals for module
        self.declare_globals(stmts, context);

        self.visit_stmts(stmts, context)
    }
}
