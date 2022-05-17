use crate::ast::Location;
use std::fmt::Display;

/// Defines a type kind.
#[derive(Debug, PartialEq, Clone, Copy)]
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

impl Clone for Type {
    fn clone(&self) -> Self {
        Self {
            name: self.name.clone(),
            kind: self.kind.clone(),
            definition_location: self.definition_location.clone(),
        }
    }
}

impl Display for Type {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{} [{:?}]", self.name, self.kind)
    }
}
