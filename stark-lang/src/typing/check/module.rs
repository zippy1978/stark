use crate::{
    ast::{self, clone_ident, Folder, Log, LogLevel},
    typing::{SymbolScope, SymbolScopeType, TypeChecker, TypeCheckerContext},
};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_fold_module(
        &mut self,
        name: &ast::Ident,
        stmts: &ast::Stmts,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::StmtKind {
        // Check current scope
        // Module in only allowed on global scope
        match context.symbol_table.current_scope() {
            Some(scope) => match scope.scope_type {
                SymbolScopeType::Global => (),
                _ => self.logger.add(Log::new_with_single_label(
                    name.location.filename.clone(),
                    "module is allowed on global scope only",
                    LogLevel::Error,
                    name.location.clone(),
                )),
            },
            None => panic!("no scope"),
        };

        // Push module scope
        context
            .symbol_table
            .push_scope(SymbolScope::new(SymbolScopeType::Module(
                name.node.to_string(),
            )));

        // Declare globals for module
        self.declare_globals(stmts, context);

        ast::StmtKind::Module {
            name: clone_ident(name),
            stmts: self.fold_stmts(stmts, context),
        }
    }
}
