/// dfdf
use std::{
    collections::{hash_map::Entry, HashMap},
    fmt::Display,
};

use crate::ast::Location;

use super::typing::Type;

#[derive(Debug, PartialEq)]
pub struct Symbol<'a> {
    pub name: String,
    pub symbol_type: &'a Type<'a>,
    pub definition_location: Location,
}

impl<'a> Display for Symbol<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{} => {}", self.name, self.symbol_type)
    }
}

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum SymbolError<'a> {
    AlreadyDefined(&'a Symbol<'a>),
    AlreadyDefinedInUpperScope(&'a Symbol<'a>),
    NoScope,
}

#[derive(Debug, PartialEq)]
pub enum SymbolScopeType {
    Global,
}

#[derive(Debug, PartialEq)]
pub struct SymbolScope<'a> {
    entries: HashMap<String, Symbol<'a>>,
    pub scope_type: SymbolScopeType,
}

impl<'a> SymbolScope<'a> {
    pub fn new(scope: SymbolScopeType) -> Self {
        Self {
            entries: HashMap::new(),
            scope_type: scope,
        }
    }

    pub(crate) fn insert(
        &mut self,
        name: &str,
        symbol_type: &'a Type,
        definition_location: Location,
    ) {
        let symbol = Symbol {
            name: name.to_string(),
            symbol_type,
            definition_location,
        };
        self.entries.insert(name.to_string(), symbol);
    }

    pub(crate) fn lookup_symbol(&self, name: &str) -> Option<&'a Symbol> {
        self.entries.get(name)
    }
}

impl<'a> Display for SymbolScope<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut out = String::new().to_owned();
        for entry in &self.entries {
            out.push_str(format!("{}\n", entry.1).as_str());
        }
        write!(f, "{:?}\n{}", self.scope_type, out)
    }
}

// Holds symbol definitions by scope.
pub struct SymbolTable<'a> {
    scopes: Vec<SymbolScope<'a>>,
}

impl<'a> SymbolTable<'a> {
    pub fn new() -> Self {
        Self { scopes: Vec::new() }
    }

    pub fn push_scope(&mut self, scope: SymbolScope<'a>) {
        self.scopes.push(scope);
    }

    pub fn pop_scope(&mut self) -> Option<SymbolScope> {
        self.scopes.pop()
    }

    pub fn current_scope(&self) -> Option<&SymbolScope> {
        self.scopes.last()
    }

    pub fn current_scope_mut(&mut self) -> Option<&mut SymbolScope<'a>> {
        self.scopes.last_mut()
    }

    pub fn lookup_symbol(&self, name: &str) -> Option<&Symbol> {
        for scope in self.scopes.iter().rev() {
            match scope.lookup_symbol(name) {
                Some(symbol) => return Some(symbol),
                None => todo!(),
            }
        }

        // Not found
        None
    }

    pub fn insert(
        &mut self,
        name: &str,
        symbol_type: &'a Type,
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
                    return Result::Err(SymbolError::AlreadyDefined(symbol));
                } else {
                    return Result::Err(SymbolError::AlreadyDefinedInUpperScope(symbol));
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

impl<'a> Display for SymbolTable<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut out = String::new().to_owned();
        for (i, scope) in self.scopes.iter().enumerate() {
            out.push_str(format!("{} - {}\n", i, scope).as_str());
        }
        write!(f, "{}", out)
    }
}
