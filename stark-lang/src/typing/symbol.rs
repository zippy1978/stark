use std::{fmt::Display};

use crate::ast::Location;

use super::typing::Type;

/// Defines a symbol.
#[derive(Debug, PartialEq)]
pub struct Symbol<V = ()> {
    pub name: String,
    pub symbol_type: Type,
    pub definition_location: Location,
    pub value: V,
}

impl Clone for Symbol {
    fn clone(&self) -> Self {
        Self {
            name: self.name.clone(),
            symbol_type: self.symbol_type.clone(),
            definition_location: self.definition_location.clone(),
            value: self.value.clone(),
        }
    }
}

impl Display for Symbol {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{} => {}", self.name, self.symbol_type)
    }
}
