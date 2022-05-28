use inkwell::values::BasicValue;

use crate::{code_gen::{CodeGenerator, CodeGenContext, VisitorResult}, ast};

impl<'ctx> CodeGenerator {
    pub(crate) fn handle_visit_name_expr(
        &mut self,
        name: &ast::Ident,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        let symbol = context.symbol_table.lookup_symbol(&name.node).unwrap();
        match symbol.value.get_type() {
            inkwell::types::AnyTypeEnum::ArrayType(_) => Result::Ok(Some(symbol.value.into_array_value().as_basic_value_enum())),
            inkwell::types::AnyTypeEnum::FloatType(_) => Result::Ok(Some(symbol.value.into_float_value().as_basic_value_enum())),
            inkwell::types::AnyTypeEnum::FunctionType(_) => todo!(),
            inkwell::types::AnyTypeEnum::IntType(_) => Result::Ok(Some(symbol.value.into_int_value().as_basic_value_enum())),
            inkwell::types::AnyTypeEnum::PointerType(_) => todo!(),
            inkwell::types::AnyTypeEnum::StructType(_) => todo!(),
            inkwell::types::AnyTypeEnum::VectorType(_) => todo!(),
            inkwell::types::AnyTypeEnum::VoidType(_) => todo!(),
        }
    }

}