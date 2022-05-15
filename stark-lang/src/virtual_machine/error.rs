/// Virtual machine error.
#[derive(Debug, PartialEq)]
pub enum VirtualMachineError {
    /// Error with bitcode loading.
    Bitcode { message: String },
    /// Error with JIT.
    JITEngine { message: String },
}
