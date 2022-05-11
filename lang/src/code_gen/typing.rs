use std::fmt::Display;

use inkwell::types::IntType as LLVMIntType;

#[derive(Debug, PartialEq)]
pub enum Type<'a> {
    Primary {
        name: &'a str,
        llvm_type: LLVMIntType<'a>,
    },
    Complex,
}

impl<'a> Display for Type<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Type::Primary { name, llvm_type } => write!(f, "{}", name),
            Type::Complex => todo!(),
        }
    }
}
