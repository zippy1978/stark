use inkwell::values::BasicValue;
use num_traits::ToPrimitive;

use crate::{code_gen::{CodeGenerator, CodeGenContext, VisitorResult}, ast};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_constant_expr(
        &mut self,
        constant: &ast::Constant,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        match constant {
            ast::Constant::Bool(_) => todo!(),
            ast::Constant::Str(_) => todo!(),
            ast::Constant::Int(value) => Result::Ok(Some(
                context
                    .llvm_context
                    .i64_type()
                    .const_int(value.to_u64().unwrap(), false)
                    .as_basic_value_enum(),
            )),
            ast::Constant::Float(value) =>  Result::Ok(Some(
                context
                    .llvm_context
                    .f64_type()
                    .const_float(*value)
                    .as_basic_value_enum(),
            )),
        }
    }
}