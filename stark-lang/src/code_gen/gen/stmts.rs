use crate::{
    ast::{self, Visitor},
    code_gen::{CodeGenContext, CodeGenerator, VisitorResult},
};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_stmts(
        &mut self,
        stmts: &ast::Stmts,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        let mut last_value = None;
        for stmt in stmts {
            match Visitor::visit_stmt(self, stmt, context) {
                Ok(value) => last_value = value,
                Err(_) => (),
            }
        }

        Result::Ok(last_value)
    }
}
