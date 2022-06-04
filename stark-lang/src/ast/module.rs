use std::collections::HashMap;

use super::{clone_args, clone_ident, Stmt, StmtKind, Stmts};

/// Holds known modules data.
pub struct ModuleMap {
    modules: HashMap<String, Stmts>,
}

impl ModuleMap {
    pub fn empty() -> Self {
        ModuleMap {
            modules: HashMap::new(),
        }
    }

    pub fn new(modules: HashMap<String, Stmts>) -> Self {
        ModuleMap { modules }
    }

    pub fn modules(&self) -> &HashMap<String, Stmts> {
        &self.modules
    }

    /// Retrieves inner AST of a given module.
    pub fn get_inner_ast(&self, name: &str) -> Option<&Stmts> {
        match self.modules.get(name) {
            Some(module_ast) => match module_ast.get(0) {
                Some(module_stmt) => match &module_stmt.node {
                    StmtKind::Module { name: _, stmts } => Some(&stmts),
                    _ => None,
                },
                None => None,
            },
            None => None,
        }
    }

    /// Builds module import declarations.
    pub fn build_import_declarations(&self, name: &str) -> Option<Stmts> {
        match self.get_inner_ast(name) {
            Some(inner_ast) => {
                let mut declarations_ast = Stmts::new();
                for stmt in inner_ast {
                    match &stmt.node {
                        StmtKind::FuncDef {
                            name: func_name,
                            args,
                            body: _,
                            returns,
                        } => {
                            let decl_node = StmtKind::FuncDecl {
                                name: clone_ident(&func_name),
                                args: Box::new(clone_args(&args)),
                                returns: match returns {
                                    Some(r) => Some(clone_ident(&r)),
                                    None => None,
                                },
                            };
                            declarations_ast.push(Stmt {
                                location: stmt.location.clone(),
                                node: decl_node,
                                info: stmt.info.clone(),
                            });
                        }
                        _ => (),
                    }
                }
                Some(declarations_ast)
            }
            None => None,
        }
    }
}
