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

/// Holds every type defined during code generation.
pub struct TypeRegistry {
    entries: HashMap<String, Type>,
}

/// Holds known types at code generation time.
impl TypeRegistry {
    /// Creates new type registry.
    pub fn new() -> TypeRegistry {
        TypeRegistry {
            entries: HashMap::new(),
        }
    }

    pub fn insert(
        &mut self,
        name: &str,
        kind: TypeKind,
        definition_location: Option<Location>,
    ) {
        self.entries.insert(
            name.to_string(),
            Type {
                name: name.to_string(),
                kind,
                definition_location,
            },
        );
    }

    pub fn lookup_type(&self, name: &str) -> Option<&Type> {
        self.entries.get(name)
    }
}
