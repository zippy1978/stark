use super::CodeGenContext;

pub fn declare_globals(context: &mut CodeGenContext) {
    let fn_type = context.llvm_context.void_type().fn_type(&[], false);
    context
        .module
        .add_function("__stark_r_mm_init", fn_type, None);
}

pub fn init_mem_manager(context: &mut CodeGenContext) {
    let function = context.module.get_function("__stark_r_mm_init").unwrap();
    context.builder.build_call(function, &[], "mm_init");
}
