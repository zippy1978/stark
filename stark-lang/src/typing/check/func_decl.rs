use crate::{
    ast::{self},
    typing::{Type, TypeChecker, TypeCheckerContext, TypeKind},
};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_func_decl(
        &mut self,
        name: &ast::Ident,
        args: &ast::Args,
        returns: &Option<ast::Ident>,
        context: &mut TypeCheckerContext<'ctx>,
    ) {
        
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
                definition_location: Some(name.location.clone()),
            },
            name.location.clone(),
            (),
        ) {
            Ok(_) => (),
            Err(err) => self.log_symbol_error(&err, name),
        };
    }
}