use inkwell::{
    context::Context,
    memory_buffer::MemoryBuffer,
    types::{BasicType, BasicTypeEnum},
    AddressSpace,
};

use crate::typing::{PrimaryKind, TypeKind};

use super::CodeGenContext;

pub(crate) fn resolve_llvm_type<'ctx>(
    type_name: &str,
    context: &CodeGenContext<'ctx>,
) -> Option<BasicTypeEnum<'ctx>> {
    match context.type_registry.lookup_type(type_name) {
        Some(ty) => Some(match &ty.kind {
            crate::typing::TypeKind::Primary(kind) => match kind {
                PrimaryKind::Int(_) => context.llvm_context.i64_type().as_basic_type_enum(),
                PrimaryKind::Float(_) => context.llvm_context.f64_type().as_basic_type_enum(),
                PrimaryKind::String(_) => context
                    .llvm_context
                    .i8_type()
                    .ptr_type(AddressSpace::Generic)
                    .as_basic_type_enum(),
                PrimaryKind::Bool(_) => context.llvm_context.bool_type().as_basic_type_enum(),
            },
            TypeKind::Complex => todo!(),
            TypeKind::Function {
                args: _,
                returns: _,
            } => todo!(),
        }),
        None => None,
    }
}

/// Links a list of bitcode modules to a single bitcode module
pub(crate) fn link_bitcode_modules(
    module_name: &str,
    bitcodes: Vec::<MemoryBuffer>,
    llvm_context: &Context,
) -> Result<MemoryBuffer, String> {
    let result_module = llvm_context.create_module(module_name);
    for bitcode in bitcodes {
        match llvm_context.create_module_from_ir(bitcode) {
            Ok(module) => match result_module.link_in_module(module) {
                Ok(_) => (),
                Err(err) => return Result::Err(err.to_string()),
            },
            Err(err) => return Result::Err(err.to_string()),
        };
    }
    Result::Ok(result_module.write_bitcode_to_memory())
}
