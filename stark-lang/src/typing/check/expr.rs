use crate::{
    ast::{self, clone_expr, Log, LogLevel},
    typing::{TypeChecker, TypeCheckerContext},
};

impl<'ctx> TypeChecker {
    pub(crate) fn handle_fold_expr(
        &mut self,
        expr: &ast::Expr,
        context: &mut TypeCheckerContext<'ctx>,
    ) -> ast::Expr {
        // Check and determine type
        match &expr.node {
            // Name
            ast::ExprKind::Name { id } => match context.symbol_table.lookup_symbol(&id.node) {
                Some(symbol) => {
                    clone_expr(expr).with_type_name(symbol.symbol_type.name.to_string())
                }
                None => {
                    self.logger.add(Log::new_with_single_label(
                        format!("symbol `{}` is undefined", &id.node),
                        LogLevel::Error,
                        id.location,
                    ));

                    clone_expr(expr)
                }
            },
            // Constant
            ast::ExprKind::Constant { value } => {
                let type_name = match value {
                    ast::Constant::Bool(_) => "bool",
                    ast::Constant::Str(_) => panic!("strings are not supported yet !"),
                    ast::Constant::Int(_) => "int",
                    ast::Constant::Float(_) => "float",
                };

                clone_expr(expr).with_type_name(type_name.to_string())
            }
        }
    }
}
