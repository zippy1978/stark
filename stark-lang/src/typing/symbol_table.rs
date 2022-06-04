use std::{collections::HashMap, fmt::Display};

use crate::ast::Location;

use super::{Symbol, SymbolError, Type};

#[derive(Debug, PartialEq)]
pub enum SymbolScopeType {
    Global,
    Function(String),
    Module(String),
}

#[derive(Debug, PartialEq)]
pub struct SymbolScope<V: Clone = ()> {
    pub(crate) entries: HashMap<String, Symbol<V>>,
    pub scope_type: SymbolScopeType,
}

impl<V: Clone> SymbolScope<V> {
    pub fn new(scope: SymbolScopeType) -> Self {
        Self {
            entries: HashMap::new(),
            scope_type: scope,
        }
    }

    pub(crate) fn insert(
        &mut self,
        name: &str,
        symbol_type: Type,
        definition_location: Location,
        value: V,
    ) {
        let symbol = Symbol {
            name: name.to_string(),
            symbol_type,
            definition_location,
            value,
        };
        self.entries.insert(name.to_string(), symbol);
    }

    pub(crate) fn lookup_symbol(&self, name: &str) -> Option<&Symbol<V>> {
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
#[derive(Debug, PartialEq)]
pub struct SymbolTable<V: Clone = ()> {
    scopes: Vec<SymbolScope<V>>,
}

impl<V: Clone> SymbolTable<V> {
    pub fn new() -> Self {
        Self { scopes: Vec::new() }
    }

    pub fn push_scope(&mut self, scope: SymbolScope<V>) {
        self.scopes.push(scope);
    }

    pub fn pop_scope(&mut self) -> Option<SymbolScope<V>> {
        self.scopes.pop()
    }

    pub fn current_scope(&self) -> Option<&SymbolScope<V>> {
        self.scopes.last()
    }

    pub fn current_module_name(&self) -> Option<String> {
        for scope in self.scopes.iter().rev() {
            match &scope.scope_type {
                SymbolScopeType::Module(name) => return Some(name.clone()),
                _ => (),
            }
        }
        None
    }

    pub fn current_scope_mut(&mut self) -> Option<&mut SymbolScope<V>> {
        self.scopes.last_mut()
    }

    pub fn lookup_symbol(&self, name: &str) -> Option<&Symbol<V>> {
        for scope in self.scopes.iter().rev() {
            match scope.lookup_symbol(name) {
                Some(symbol) => return Some(symbol),
                None => (),
            }
        }

        // Not found
        None
    }

    /// Clones current scope entries and add a prefix to each of them.
    /// Returns and empty [Vec] is there is no current scope
    pub fn clone_current_scope_symbols_with_prefix(
        &self,
        prefix: &str,
    ) -> Vec<Symbol<V>> {
        let mut entries_clone = Vec::new();
        if let Some(scope) = self.current_scope() {
            for (symbol_name, symbol) in &scope.entries {
                let new_symbol_name = format!("{}{}", prefix, symbol_name);
                let mut new_symbol = symbol.clone();
                new_symbol.name = new_symbol_name.to_string();
                entries_clone.push(new_symbol);
            }
        }
        entries_clone
    }

    /// Insert multiple symbols inot current scope
    pub fn insert_all(
        &mut self,
        symbols: Vec<Symbol<V>>,
    ) -> Result<(), SymbolError<V>> {
        for symbol in symbols {
            match self.insert(
                &symbol.name,
                symbol.symbol_type,
                symbol.definition_location,
                symbol.value,
            ) {
                Ok(_) => (),
                Err(err) => return Result::Err(err),
            }
        }

        Result::Ok(())
    }

    pub fn insert(
        &mut self,
        name: &str,
        symbol_type: Type,
        definition_location: Location,
        value: V,
    ) -> Result<(), SymbolError<V>> {
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
                    return Result::Err(SymbolError::AlreadyDefined((*symbol).clone()));
                } else {
                    return Result::Err(SymbolError::AlreadyDefinedInUpperScope(symbol.clone()));
                }
            }
            None => {
                self.current_scope_mut().unwrap().insert(
                    name,
                    symbol_type,
                    definition_location,
                    value,
                );
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
