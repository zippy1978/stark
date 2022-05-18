use std::{fmt::Display, collections::HashMap};

use crate::ast::Location;

use super::{Type, SymbolError, Symbol};


#[derive(Debug, PartialEq)]
pub enum SymbolScopeType {
    Global,
}

#[derive(Debug, PartialEq)]
pub struct SymbolScope {
    pub(crate) entries: HashMap<String, Symbol>,
    pub scope_type: SymbolScopeType,
}

impl SymbolScope {
    pub fn new(scope: SymbolScopeType) -> Self {
        Self {
            entries: HashMap::new(),
            scope_type: scope,
        }
    }

    pub(crate) fn insert(&mut self, name: &str, symbol_type: Type, definition_location: Location) {
        let symbol = Symbol {
            name: name.to_string(),
            symbol_type,
            definition_location,
            value: (),
        };
        self.entries.insert(name.to_string(), symbol);
    }

    pub(crate) fn lookup_symbol(&self, name: &str) -> Option<&Symbol> {
        self.entries.get(name)
    }
}

impl Display for SymbolScope {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut out = String::new().to_owned();
        for entry in &self.entries {
            out.push_str(format!("{}\n", entry.1).as_str());
        }
        write!(f, "{:?}\n{}", self.scope_type, out)
    }
}

// Holds symbol definitions by scope.
pub struct SymbolTable {
    scopes: Vec<SymbolScope>,
}

impl SymbolTable {
    pub fn new() -> Self {
        Self { scopes: Vec::new() }
    }

    pub fn push_scope(&mut self, scope: SymbolScope) {
        self.scopes.push(scope);
    }

    pub fn pop_scope(&mut self) -> Option<SymbolScope> {
        self.scopes.pop()
    }

    pub fn current_scope(&self) -> Option<&SymbolScope> {
        self.scopes.last()
    }

    pub fn current_scope_mut(&mut self) -> Option<&mut SymbolScope> {
        self.scopes.last_mut()
    }

    pub fn lookup_symbol(&self, name: &str) -> Option<&Symbol> {
        for scope in self.scopes.iter().rev() {
            match scope.lookup_symbol(name) {
                Some(symbol) => return Some(symbol),
                None => (),
            }
        }

        // Not found
        None
    }

    pub fn insert(
        &mut self,
        name: &str,
        symbol_type: Type,
        definition_location: Location,
    ) -> Result<(), SymbolError> {
        if self.scopes.len() == 0 {
            return Result::Err(SymbolError::NoScope);
        }

        let mut found_scope_index: Option<usize> = None;
        for (i, scope) in self.scopes.iter().rev().enumerate() {
            if scope.entries.contains_key(name) {
                // Don't forget the iteration is reverse !
                found_scope_index = Some(self.scopes.len() - 1 - i);
                break;
            }
        }

        // Retrieve existing or create new symbol
        match found_scope_index {
            Some(i) => {
                let scope = self.scopes.get(i).unwrap();
                let symbol = scope.entries.get(name).unwrap();

                if i == self.scopes.len() - 1 {
                    return Result::Err(SymbolError::AlreadyDefined(symbol.clone()));
                } else {
                    return Result::Err(SymbolError::AlreadyDefinedInUpperScope(symbol.clone()));
                }
            }
            None => {
                self.current_scope_mut()
                    .unwrap()
                    .insert(name, symbol_type, definition_location);
                Result::Ok(())
            }
        }
    }
}

impl<'a> Display for SymbolTable {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut out = String::new().to_owned();
        for (i, scope) in self.scopes.iter().enumerate() {
            out.push_str(format!("{} - {}\n", i, scope).as_str());
        }
        write!(f, "{}", out)
    }
}