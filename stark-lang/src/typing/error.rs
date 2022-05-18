use crate::ast::Log;

use super::Symbol;


pub struct TypeCheckerError {
    pub logs: Vec<Log>,
}

#[derive(Debug, PartialEq)]
pub enum SymbolError {
    AlreadyDefined(Symbol),
    AlreadyDefinedInUpperScope(Symbol),
    NoScope,
}