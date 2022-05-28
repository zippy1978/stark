use crate::{
    ast::{self, Folder, Log, LogLevel},
    typing::{TypeChecker, TypeCheckerContext},
};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_fold_assign(
        &mut self,
        target: &ast::Expr,
        value: &ast::Expr,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::StmtKind {
        let folded_target = self.fold_expr(target, context);
        let folded_value = self.fold_expr(value, context);

        match &folded_value.info.type_name {
            Some(target_type_name) => match &folded_target.info.type_name {
                Some(value_type_name) => {
                    if target_type_name != value_type_name {
                        self.logger.add(Log::new_with_single_label(
                            format!(
                                "type mismatch, expected `{}`, found `{}`",
                                target_type_name, value_type_name
                            ),
                            LogLevel::Error,
                            value.location,
                        ));
                    }
                }
                None => {
                    self.logger.add(Log::new_with_single_label(
                        "unable to determine expression type",
                        LogLevel::Error,
                        value.location,
                    ));
                }
            },
            None => {
                self.logger.add(Log::new_with_single_label(
                    "unable to determine expression type",
                    LogLevel::Error,
                    value.location,
                ));
            }
        };

        ast::StmtKind::Assign {
            target: Box::new(folded_target),
            value: Box::new(folded_value),
        }
    }
}