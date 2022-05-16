use std::collections::HashMap;

use crate::ast::Location;

use super::{Type, TypeKind};


/// Holds every type defined.
pub struct TypeRegistry {
    entries: HashMap<String, Type>,
}

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

    pub fn clear(&mut self) {
        self.entries.clear();
    }
}