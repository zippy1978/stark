use crate::ast::Log;

#[derive(Debug, PartialEq)]
pub struct CodeGenError {
    pub logs: Vec<Log>,
}
