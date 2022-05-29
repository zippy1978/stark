use inkwell::{types::StringRadix, values::BasicValue};

use crate::{
    ast,
    code_gen::{CodeGenContext, CodeGenerator, VisitorResult},
};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_constant_expr(
        &mut self,
        constant: &ast::Constant,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        match constant {
            ast::Constant::Bool(value) => Result::Ok(Some(
                context
                    .llvm_context
                    .bool_type()
                    .const_int(if *value { 1 } else { 0 }, false)
                    .as_basic_value_enum(),
            )),
            ast::Constant::Str(_) => todo!(),
            ast::Constant::Int(value) => Result::Ok(Some(
                context
                    .llvm_context
                    .i64_type()
                    .const_int_from_string(&value.to_string(), StringRadix::Decimal)
                    .unwrap()
                    .as_basic_value_enum(),
            )),
            ast::Constant::Float(value) => Result::Ok(Some(
                context
                    .llvm_context
                    .f64_type()
                    .const_float(*value)
                    .as_basic_value_enum(),
            )),
        }
    }
}
