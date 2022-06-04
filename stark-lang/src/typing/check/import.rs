use crate::{
    ast::{self, clone_ident, Log, LogLevel, Folder},
    typing::{SymbolScopeType, TypeChecker, TypeCheckerContext, SymbolScope},
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

         // Push module scope in order to get module related symbol names
         context
         .symbol_table
         .push_scope(SymbolScope::new(crate::typing::SymbolScopeType::Module(
             name.node.to_string(),
         )));

        // Process module declarations
        match context.module_map.build_import_declarations(&name.node) {
            Some(import_decl) => {
                for decl in import_decl {
                    match decl.node {
                        ast::StmtKind::FuncDecl {
                            name,
                            args,
                            returns,
                        } => {
                            self.fold_func_decl(&name, &args, &returns, context);
                        }
                        _ => (),
                    };
                }
            }
            None => self.logger.add(Log::new_with_single_label(
                name.location.filename.clone(),
                format!("module `{}` not found", &name.node),
                LogLevel::Error,
                name.location.clone(),
            )),
        }

         // Need to bring back module scope symbols to global scope
        // 1. copy and rename (with module prefix) generated symbols
        let module_symbols = context
            .symbol_table
            .clone_current_scope_symbols_with_prefix(format!("{}.", name.node).as_str());

        // 2. pop module scope
        context.symbol_table.pop_scope();

        // 3. bring module symbols on globals cope
        match context.symbol_table.insert_all(module_symbols) {
            Ok(_) => (),
            Err(err) => self.log_symbol_error(&err, name),
        };

        ast::StmtKind::Import {
            name: clone_ident(name),
        }
    }
}
