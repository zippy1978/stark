use crate::ast::Log;

pub enum TypeCheckError {
    UnknownType(String)
}

pub struct TypeCheckerError {
    pub logs: Vec<Log>,
}