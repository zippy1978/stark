use std::{collections::HashMap};

use crate::ast;

use super::clone_stmts;

/// Holds known modules data.
pub struct ModuleMap {
    modules: HashMap<String, ast::Stmts>,
}

impl ModuleMap {

    pub fn new(modules:  HashMap<String, ast::Stmts>) -> Self {
        ModuleMap { modules }
    }

    /// Extract global declarations from a given module.
    pub fn get_globals(&self, module_name: &str) -> Result<ast::Stmts, ()> {
        // TODO : just return full AST at the moment
        // To continue
        match self.modules.get(module_name) {
            Some(ast) => Result::Ok(clone_stmts(ast)),
            None => Result::Err(()),
        }
    }

    pub fn modules(&self) -> &HashMap<String, ast::Stmts> {
        &self.modules
    }
}

