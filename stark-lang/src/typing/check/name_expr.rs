use crate::{
    ast::{self, clone_expr, Log, LogLevel},
    typing::{TypeChecker, TypeCheckerContext},
};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_fold_name_expr(
        &mut self,
        expr: &ast::Expr,
        id: &ast::Ident,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::Expr {
        match context.symbol_table.lookup_symbol(&id.node) {
            Some(symbol) => clone_expr(expr).with_type_name(symbol.symbol_type.name.to_string()),
            None => {
                self.logger.add(Log::new_with_single_label(
                    format!("symbol `{}` is undefined", &id.node),
                    LogLevel::Error,
                    id.location,
                ));

                clone_expr(expr)
            }
        }
    }
}
