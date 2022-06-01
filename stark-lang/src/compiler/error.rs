use crate::{
    ast::{Log, LogLevel},
    parser::ParseError,
};

#[derive(Debug, PartialEq)]
pub struct CompileError {
    pub logs: Vec<Log>,
}

impl From<ParseError> for CompileError {
    fn from(err: ParseError) -> Self {
        let mut compile_error = CompileError::new();
        let log = Log::new(err.location.filename.clone(), "syntax error", LogLevel::Error)
            .with_label(err.to_string(), err.location);
        compile_error.logs.push(log);
        compile_error
    }
}

pub enum CompileErrorKind {}

impl CompileError {
    pub fn new() -> Self {
        CompileError { logs: Vec::new() }
    }
}
