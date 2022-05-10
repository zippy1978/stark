use inkwell::types::IntType as LLVMIntType;

pub enum Type {
    Primary,
    Complex,
}

pub enum PrimaryType {
    Int,
    Double,
    Bool
}

pub struct IntType<'a> {
    name: &'a str,
    llvm_type: LLVMIntType<'a>,
}
