use crate::{
    ast::{self, clone_expr, clone_ident, ExprKind, Folder, Log, LogLevel},
    typing::{TypeChecker, TypeCheckerContext},
};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_fold_call_expr(
        &mut self,
        expr: &ast::Expr,
        id: &ast::Ident,
        params: &ast::Params,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::Expr {
        // Fold params
        let mut folded_params = ast::Params::new();
        for param_expr in params {
            folded_params.push(self.fold_expr(param_expr, context));
        }

        match context.symbol_table.lookup_symbol(&id.node) {
            Some(symbol) => {
                match &symbol.symbol_type.kind {
                    crate::typing::TypeKind::Function { args, returns } => {
                        // Check param count
                        if args.len() != params.len() {
                            self.logger.add(Log::new_with_single_label(
                                id.location.filename.clone(),
                            format!("wrong parameter count: `{}` is exprecting {} parameter(s) not {}", &id.node, args.len(), params.len()),
                            LogLevel::Error,
                            id.location.clone(),
                        ));
                        } else {
                            // Check param type
                            for (i, folded_param) in folded_params.iter().enumerate() {
                                match &folded_param.info.type_name {
                                    Some(type_name) => {
                                        if type_name != &args[i] {
                                            self.logger.add(Log::new_with_single_label(
                                                folded_param.location.filename.clone(),
                                                format!(
                                                    "type mismatch, expected `{}`, found `{}`",
                                                    args[i], type_name
                                                ),
                                                LogLevel::Error,
                                                folded_param.location.clone(),
                                            ))
                                        }
                                    }
                                    None => self.log_undetermined_expression_type(folded_param),
                                }
                            }
                        }

                        // Fold with return type (if any)
                        match returns {
                            Some(ty) => clone_expr(expr).with_type_name(ty.to_string()).with_node(
                                ExprKind::Call {
                                    id: clone_ident(id),
                                    params: Box::new(folded_params),
                                },
                            ),
                            None => clone_expr(expr),
                        }
                    }
                    _ => {
                        self.logger.add(Log::new_with_single_label(
                            id.location.filename.clone(),
                            format!("`{}` is not callable", &id.node),
                            LogLevel::Error,
                            id.location.clone(),
                        ));
                        clone_expr(expr).with_node(ExprKind::Call {
                            id: clone_ident(id),
                            params: Box::new(folded_params),
                        })
                    }
                }
            }
            None => {
                self.log_undefined_symbol(id);

                clone_expr(expr).with_node(ExprKind::Call {
                    id: clone_ident(id),
                    params: Box::new(folded_params),
                })
            }
        }
    }
}
