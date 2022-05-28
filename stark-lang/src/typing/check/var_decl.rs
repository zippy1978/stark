use crate::{
    ast::{self, Log, LogLevel, clone_ident},
    typing::{TypeChecker, TypeCheckerContext, SymbolScopeType},
};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_fold_var_decl(
        &mut self,
        name: &ast::Ident,
        var_type: &ast::Ident,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::StmtKind {
        // Check current scope
        // Variable declaration is not allowed in global scope
        match context.symbol_table.current_scope() {
            Some(scope) => match scope.scope_type {
                SymbolScopeType::Global => self.logger.add(Log::new_with_single_label(
                    "variable delcaration is not allowed on global scope",
                    LogLevel::Error,
                    name.location,
                )),
                _ => (),
            },
            None => panic!("no scope"),
        };

        // Check if type exists
        match context.type_registry.lookup_type(&var_type.node) {
            Some(ty) => {
                // Try to insert new symbol
                match context
                    .symbol_table
                    .insert(&name.node, ty.clone(), name.location, ())
                {
                    Ok(_) => (),
                    Err(err) => self.log_symbol_error(&err, name),
                }
            }
            None => self.log_unknown_type(var_type),
        };

        ast::StmtKind::VarDecl {
            name: clone_ident(name).with_type_name(var_type.node.to_string()),
            var_type: clone_ident(var_type),
        }
    }
}