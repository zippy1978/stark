use crate::{
    ast::{self, Log, LogLevel},
    typing::{TypeChecker, TypeCheckerContext, SymbolScopeType},
};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_fold_import(
        &mut self,
        name: &ast::Ident,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::StmtKind {

        // Check current scope
        // Import in only allowed on global scope
        match context.symbol_table.current_scope() {
            Some(scope) => match scope.scope_type {
                SymbolScopeType::Global => (),
                _ => self.logger.add(Log::new_with_single_label(
                    name.location.filename.clone(),
                    "import is allowed on global scope only",
                    LogLevel::Error,
                    name.location.clone(),
                )),
            },
            None => panic!("no scope"),
        };

        // Resolve import and generate global declarations here ?
        todo!()
    }
}
