use std::{collections::HashMap, path::PathBuf};

use crate::{
    ast::{wrap_ast_in_module, ModuleMap},
    parser::Parser,
};

use super::ModuleError;

impl ModuleMap {
    fn module_name_for_path(path: &PathBuf) -> Result<Option<String>, ModuleError> {
        match path.parent() {
            Some(parent) => {
                // For some reason parent name may be empty
                if parent.to_str().unwrap().is_empty() {
                    return Result::Ok(None);
                }
                let parent_name = parent
                    .components()
                    .last()
                    .unwrap()
                    .as_os_str()
                    .to_str()
                    .unwrap()
                    .to_string();
                if parent_name.ends_with(".mod") {
                    match ModuleMap::module_name_for_path(&parent.to_path_buf()) {
                        Ok(r) => match r {
                            Some(_) => Result::Err(ModuleError::NestedModule(parent_name)),
                            None => Result::Ok(Some(
                                parent_name.strip_suffix(".mod").unwrap().to_string(),
                            )),
                        },
                        Err(err) => Result::Err(err),
                    }
                } else {
                    ModuleMap::module_name_for_path(&parent.to_path_buf())
                }
            }
            None => Result::Ok(None),
        }
    }

    /// Creates a [ModuleMap] from paths.
    /// Lookup each file path and determine if it is part of a module.
    pub fn from_paths(paths: &[PathBuf]) -> Result<ModuleMap, ModuleError> {
        // Determine each source file module
        let mut module_files = HashMap::new();
        for path in paths {
            let module_name = match ModuleMap::module_name_for_path(path) {
                Ok(r) => match r {
                    Some(name) => name,
                    None => "main".to_string(),
                },
                Err(err) => return Result::Err(err),
            };

            if let None = module_files.get(&module_name) {
                module_files.insert(module_name.to_string(), Vec::new());
            }
            let module_paths = module_files.get_mut(&module_name).unwrap();
            module_paths.push(path.to_path_buf());
        }

        // Parse each module files
        let parser = Parser::new();
        let mut modules = HashMap::new();
        for (module_name, module_paths) in &module_files {
            match parser.parse_files(&module_paths[..]) {
                Ok(ast) => {
                    modules.insert(
                        module_name.to_string(),
                        if module_name == "main" {
                            ast
                        } else {
                            wrap_ast_in_module(&ast, module_name)
                        },
                    );
                }
                Err(err) => return Result::Err(ModuleError::ParseError(err)),
            };
        }

        Result::Ok(ModuleMap::new(modules))
    }
}
