use super::Log;

#[derive(Debug, PartialEq)]
pub struct CodeGenError<'ctx> {
    pub logs: Vec<Log<'ctx>>,
}

impl<'a> CodeGenError<'a> {
    pub fn new() -> Self {
        CodeGenError { logs: Vec::new() }
    }
}
