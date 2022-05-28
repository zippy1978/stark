use crate::ast::Log;

use super::Symbol;


pub struct TypeCheckerError {
    pub logs: Vec<Log>,
}

#[derive(Debug, PartialEq)]
pub enum SymbolError<V: Clone> {
    AlreadyDefined(Symbol<V>),
    AlreadyDefinedInUpperScope(Symbol<V>),
    NoScope,
}