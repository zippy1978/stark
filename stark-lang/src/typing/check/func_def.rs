use crate::{
    ast::{self, clone_args, clone_ident, Folder, Log, LogLevel},
    typing::{SymbolScope, SymbolScopeType, Type, TypeChecker, TypeCheckerContext, TypeKind},
};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_fold_func_def(
        &mut self,
        name: &ast::Ident,
        args: &ast::Args,
        body: &ast::Stmts,
        returns: &Option<ast::Ident>,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::StmtKind {
        // Check current scope
        // Function declaration in only allowed on global scope
        match context.symbol_table.current_scope() {
            Some(scope) => match scope.scope_type {
                SymbolScopeType::Global => (),
                _ => self.logger.add(Log::new_with_single_label(
                    "function delcaration is not allowed in this scope",
                    LogLevel::Error,
                    name.location,
                )),
            },
            None => panic!("no scope"),
        };

        // Check arg types
        for arg in args {
            match context.type_registry.lookup_type(&arg.var_type.node) {
                Some(_) => (),
                None => self.log_unknown_type(&arg.var_type),
            }
        }

        // Check return type
        match returns {
            Some(return_type) => match context.type_registry.lookup_type(&return_type.node) {
                Some(_) => (),
                None => self.log_unknown_type(&return_type),
            },
            None => (),
        }

        // Insert symbol
        match context.symbol_table.insert(
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
                definition_location: Some(name.location),
            },
            name.location,
            (),
        ) {
            Ok(_) => (),
            Err(err) => self.log_symbol_error(&err, name),
        };

        // Push scope
        context
            .symbol_table
            .push_scope(SymbolScope::new(SymbolScopeType::Function(
                name.node.to_string(),
            )));

        // Insert args symbols into function scope
        for arg in args {
            match context.type_registry.lookup_type(&arg.var_type.node) {
                Some(ty) => match context.symbol_table.insert(
                    &arg.name.node.clone(),
                    ty.clone(),
                    arg.name.location,
                    (),
                ) {
                    Ok(_) => (),
                    Err(err) => self.log_symbol_error(&err, &arg.name),
                },
                None => (),
            }
        }

        // Fold body
        let folded_body = Folder::fold_stmts(self, body, context);

        // Check return instruction (last of body)
        if let Some(returns) = returns {
            match folded_body.last() {
                Some(last_stmt) => match &last_stmt.node {
                    ast::StmtKind::Expr { value } => match &value.info.type_name {
                        Some(type_name) => {
                            if type_name != &returns.node {
                                self.logger.add(
                                    Log::new_with_single_label(
                                        format!(
                                            "type mismatch, expected `{}` return, found `{}`",
                                            returns.node, type_name
                                        ),
                                        LogLevel::Error,
                                        last_stmt.location,
                                    )
                                    .with_label(
                                        format!(
                                            "function `{}` return type is `{}`",
                                            &name.node, &returns.node
                                        ),
                                        returns.location,
                                    ),
                                );
                            }
                        }
                        None => {
                            self.logger.add(Log::new_with_single_label(
                                "unable to determine expression type",
                                LogLevel::Error,
                                last_stmt.location,
                            ));
                        }
                    },
                    _ => {
                        self.logger.add(Log::new_with_single_label(
                            "function return is missing",
                            LogLevel::Error,
                            last_stmt.location,
                        ));
                    }
                },
                None => (),
            }
        };

        // Fold new node
        let new_func_def = ast::StmtKind::FuncDef {
            name: clone_ident(name),
            args: Box::new(clone_args(args)),
            body: folded_body,
            returns: match returns {
                Some(ident) => Some(clone_ident(ident)),
                None => None,
            },
        };

        // Pop scope
        context.symbol_table.pop_scope();

        new_func_def
    }
}
