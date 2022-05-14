use crate::ast::Log;

#[derive(Debug, PartialEq)]
pub struct CompileError {
    pub logs: Vec<Log>,
}

pub enum CompileErrorKind {
    
}

impl CompileError {
    pub fn new() -> Self {
        CompileError { logs: Vec::new() }
    }
}
