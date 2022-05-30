use crate::{
    ast::{self, clone_ident, Folder, Log, LogLevel},
    typing::{TypeChecker, TypeCheckerContext},
};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_fold_assign(
        &mut self,
        target: &ast::Ident,
        value: &ast::Expr,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::StmtKind {
        let folded_value = self.fold_expr(value, context);

        match context.symbol_table.lookup_symbol(&target.node) {
            Some(symbol) => match &folded_value.info.type_name {
                Some(value_type_name) => {
                    if value_type_name != &symbol.symbol_type.name {
                        self.logger.add(Log::new_with_single_label(
                            format!(
                                "type mismatch, expected `{}`, found `{}`",
                                symbol.symbol_type.name, value_type_name
                            ),
                            LogLevel::Error,
                            value.location,
                        ));
                    }
                }
                None => self.log_undetermined_expression_type(value),
            },
            None => self.log_undefined_symbol(&target),
        };

        ast::StmtKind::Assign {
            target: clone_ident(target),
            value: Box::new(folded_value),
        }
    }
}
