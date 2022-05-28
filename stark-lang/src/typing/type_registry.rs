use std::collections::HashMap;

use crate::ast::Location;

use super::{Type, TypeKind, PrimaryKind};

/// Holds every type defined.
pub struct TypeRegistry {
    entries: HashMap<String, Type>,
}

impl TypeRegistry {
    /// Creates new type registry.
    pub fn new() -> TypeRegistry {
        // Builtin types
        let mut entries = HashMap::new();
        // int
        let int_name = "int";
        entries.insert(
            int_name.to_string(),
            Type {
                name: int_name.to_string(),
                kind: super::TypeKind::Primary(PrimaryKind::Int(int_name.to_string())),
                definition_location: None,
            },
        );
        //float
        let float_name = "float";
        entries.insert(
            float_name.to_string(),
            Type {
                name: float_name.to_string(),
                kind: super::TypeKind::Primary(PrimaryKind::Float(float_name.to_string())),
                definition_location: None,
            },
        );
        //bool
        let bool_name = "bool";
        entries.insert(
            bool_name.to_string(),
            Type {
                name: bool_name.to_string(),
                kind: super::TypeKind::Primary(PrimaryKind::Bool(bool_name.to_string())),
                definition_location: None,
            },
        );

        TypeRegistry { entries }
    }

    pub fn insert(&mut self, name: &str, kind: TypeKind, definition_location: Option<Location>) {
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

    pub fn to_vec(&self) -> Vec<Type> {
        let mut result = Vec::new();
        for (_key, value) in &self.entries {
            result.push(value.clone());
        }
        result
    }

}
