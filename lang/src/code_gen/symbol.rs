/// dfdf

use std::{collections::HashMap, fmt::Display};

use crate::ast::Location;

use super::typing::Type;

#[derive(Debug, PartialEq)]
pub struct Symbol<'a> {
    pub name: String,
    pub symbol_type: Type<'a>,
    pub definition_location: Location,
}

impl<'a> Display for Symbol<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{} => {}", self.name, self.symbol_type)
    }
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

    pub fn insert(&mut self, name: &String, symbol_type: Type<'a>, definition_location: Location) {
        self.entries.insert(name.to_string(), Symbol { name: name.to_string(), symbol_type, definition_location});
    }

    pub fn lookup_symbol(&self, name: &str) -> Option<&Symbol> {
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

pub enum SymbolTableError {}

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
}

impl<'a> Display for SymbolTable<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut out = String::new().to_owned();
        for scope in &self.scopes {
            out.push_str(format!("{}\n", scope).as_str());
        }
        write!(f, "{}", out)
    }
}