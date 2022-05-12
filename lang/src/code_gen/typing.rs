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
pub struct Type<'a> {
    pub name: String,
    pub kind: TypeKind,
    pub llvm_type: LLVMIntType<'a>,
    pub definition_location: Option<Location>,
}

impl<'a> Display for Type<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{} [{:?}]", self.name, self.kind)
    }
}

/// Holds every type defined during code generation.
pub struct TypeRegistry<'a> {
    entries: HashMap<String, Type<'a>>,
}

/// Holds known types at code generation time.
impl<'a> TypeRegistry<'a> {
    /// Creates new type registry.
    pub fn new() -> TypeRegistry<'a> {
        TypeRegistry {
            entries: HashMap::new(),
        }
    }

    pub fn insert(
        &mut self,
        name: &str,
        kind: TypeKind,
        llvm_type: LLVMIntType<'a>,
        definition_location: Option<Location>,
    ) {
        self.entries.insert(
            name.to_string(),
            Type {
                name: name.to_string(),
                kind,
                llvm_type,
                definition_location,
            },
        );
    }

    pub fn lookup_type(&self, name: &str) -> Option<&Type> {
        self.entries.get(name)
    }
}
