use std::{
    collections::HashMap,
    fs::{self, File},
    io::Write,
    path::PathBuf,
};

use tempfile::TempDir;

use crate::ast::ModuleMap;


fn paths_from_sources(root_dir: &TempDir, sources: HashMap<String, String>) -> Vec<PathBuf> {
    let mut paths = Vec::<PathBuf>::new();
    for (filename, content) in &sources {
        let path = PathBuf::from(root_dir.path()).join(PathBuf::from(filename));
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent).unwrap();
        }

        let mut file = File::create(&path).unwrap();
        file.write_all(&content.as_bytes()).unwrap();
        paths.push(path);
    }

    paths
}

#[test]
fn module_map_from_paths() {
    let root_dir = tempfile::tempdir().unwrap();

    let mut sources = HashMap::new();
    sources.insert("main.st".to_string(), "func main() => int {0}".to_string());
    let paths = paths_from_sources(&root_dir, sources);

    match ModuleMap::from_paths(&paths[..]) {
        Ok(module_map) => assert_eq!(module_map.modules().len(), 1),
        Err(err) => panic!("error : {:?}", &err),
    }
}

#[test]
fn module_map_from_paths_with_module() {
    let root_dir = tempfile::tempdir().unwrap();

    let mut sources = HashMap::new();
    sources.insert("main.st".to_string(), "func main() => int {0}".to_string());
    sources.insert(
        "lib.mod/lib.st".to_string(),
        "func myFunc() => int {0}".to_string(),
    );
    let paths = paths_from_sources(&root_dir, sources);

    match ModuleMap::from_paths(&paths[..]) {
        Ok(module_map) => {
            assert!(module_map.modules().get("main").is_some());
            assert!(module_map.modules().get("lib").is_some());
        }
        Err(err) => panic!("error : {:?}", &err),
    }
}

#[test]
fn module_map_from_paths_with_nested_modules() {
    let root_dir = tempfile::tempdir().unwrap();

    let mut sources = HashMap::new();
    sources.insert("main.st".to_string(), "func main() => int {0}".to_string());
    sources.insert(
        "lib.mod/lib.st".to_string(),
        "func myFunc() => int {0}".to_string(),
    );
    sources.insert(
        "lib.mod/sub.mod/sub.st".to_string(),
        "func mySubFunc() => int {0}".to_string(),
    );
    let paths = paths_from_sources(&root_dir, sources);

    match ModuleMap::from_paths(&paths[..]) {
        Ok(_) => panic!("nested modules is not allowed"),
        Err(_) => assert!(true),
    }
}
