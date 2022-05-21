use crate::ast::Location;
use std::fmt::Display;

#[derive(Debug, PartialEq)]
pub enum PrimaryKind {
    Int(String),
    Float(String),
    String(String),
    Bool(String),
}

impl Clone for PrimaryKind {
    fn clone(&self) -> Self {
        match self {
            Self::Int(name) => Self::Int(name.clone()),
            Self::Float(name) => Self::Float(name.clone()),
            Self::String(name) => Self::String(name.clone()),
            Self::Bool(name) => Self::Bool(name.clone()),
        }
    }
}

/// Defines a type kind.
#[derive(Debug, PartialEq)]
pub enum TypeKind {
    Primary(PrimaryKind),
    Complex,
    Function {
        args: Vec<String>,
        returns: Option<String>,
    },
}

impl Clone for TypeKind {
    fn clone(&self) -> Self {
        match self {
            Self::Primary(kind) => Self::Primary(kind.clone()),
            Self::Complex => Self::Complex,
            Self::Function { args, returns } => Self::Function {
                args: args.clone(),
                returns: returns.clone(),
            },
        }
    }
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
