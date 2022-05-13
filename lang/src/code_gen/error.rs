use super::Log;

#[derive(Debug, PartialEq)]
pub struct CodeGenError {
    pub logs: Vec<Log>,
}

impl CodeGenError {
    pub fn new() -> Self {
        CodeGenError { logs: Vec::new() }
    }
}
