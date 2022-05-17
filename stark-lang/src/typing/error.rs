use crate::ast::Log;

use super::Symbol;

#[derive(Debug, PartialEq)]
pub enum TypeCheckError {
    UnknownType(String),
    SymbolAlreadyDeclared(String),
    SymbolNotFound(String),
    Scope,

}

pub struct TypeCheckerError {
    pub logs: Vec<Log>,
}

#[derive(Debug, PartialEq)]
pub enum SymbolError {
    AlreadyDefined(Symbol),
    AlreadyDefinedInUpperScope(Symbol),
    NoScope,
}