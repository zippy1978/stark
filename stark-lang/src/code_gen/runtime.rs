use inkwell::module::Linkage;

use super::CodeGenContext;

enum RuntimeFunction {
    MemManagerInit,
}

impl RuntimeFunction {
    fn as_str(&self) -> &'static str {
        match self {
            RuntimeFunction::MemManagerInit => "__stark_r_mm_init",
        }
    }
}

pub fn declare_globals(context: &mut CodeGenContext) {
    let fn_type = context.llvm_context.void_type().fn_type(&[], false);
    context
        .module
        .add_function(RuntimeFunction::MemManagerInit.as_str(), fn_type, Some(Linkage::External));
}

pub fn init_mem_manager(context: &mut CodeGenContext) {
    let function = context.module.get_function(RuntimeFunction::MemManagerInit.as_str()).unwrap();
    context.builder.build_call(function, &[], "mm_init");
}
