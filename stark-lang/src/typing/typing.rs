use crate::ast::Location;
use inkwell::types::IntType as LLVMIntType;
use std::{collections::HashMap, fmt::Display};

/// Defines a type kind.
#[derive(Debug, PartialEq)]
pub enum TypeKind {
    Primary,
    Complex,
}

/// Defines a type.
#[derive(Debug, PartialEq)]
pub struct Type {
    pub name: String,
    pub kind: TypeKind,
    pub definition_location: Option<Location>,
}

impl Display for Type {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{} [{:?}]", self.name, self.kind)
    }
}
