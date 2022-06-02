
use super::{SymbolError, SymbolScope, SymbolScopeType, SymbolTable, TypeRegistry};
use crate::ast::{Location, Span};

#[test]
fn push_scope() {
    let mut table = SymbolTable::<()>::new();

    if let Some(_current_scope) = table.current_scope() {
        panic!();
    }

    table.push_scope(SymbolScope::new(SymbolScopeType::Global));

    match table.current_scope() {
        Some(scope) => assert_eq!(scope.scope_type, SymbolScopeType::Global),
        None => panic!(),
    }
}

#[test]
fn pop_scope() {
    let mut table = SymbolTable::<()>::new();
    table.push_scope(SymbolScope::new(SymbolScopeType::Global));
    table.pop_scope();

    match table.current_scope() {
        Some(_) => panic!(),
        None => assert!(true),
    }
}

#[test]
fn lookup_symbol() {
    let type_registry = TypeRegistry::new();
    let mut table = SymbolTable::new();
    table.push_scope(SymbolScope::new(SymbolScopeType::Global));

    // Insert var1
    let insert_result1 = table.insert(
        "var1",
        type_registry.lookup_type("int").unwrap().clone(),
        Location::new(0, 0, Span::new(0, 0), "-"),
        (),
    );

    // Expect to be ok
    match insert_result1 {
        Ok(_) => match table.lookup_symbol("var1") {
            Some(symbol) => assert_eq!(symbol.name, "var1"),
            None => panic!(),
        },
        Err(_) => panic!(),
    }

    // Insert var1 a second time (same scope)
    let insert_result2 = table.insert(
        "var1",
        type_registry.lookup_type("int").unwrap().clone(),
        Location::new(0, 0, Span::new(0, 0), "-"),
        (),
    );

    // Expect to be error
    match insert_result2 {
        Ok(_) => panic!(),

        Err(err) => match err {
            SymbolError::AlreadyDefined(symbol) => {
                assert_eq!(symbol.name, "var1")
            }
            SymbolError::AlreadyDefinedInUpperScope(_) => panic!(),
            SymbolError::NoScope => panic!(),
        },
    }

    // Push a seconde scope
    table.push_scope(SymbolScope::new(SymbolScopeType::Global));

    // Insert var1 a third time
    let insert_result3 = table.insert(
        "var1",
        type_registry.lookup_type("int").unwrap().clone(),
        Location::new(0, 0, Span::new(0, 0), "-"),
        (),
    );

    // Expect to be error
    match insert_result3 {
        Ok(_) => panic!(),

        Err(err) => match err {
            SymbolError::AlreadyDefined(_) => panic!(),
            SymbolError::AlreadyDefinedInUpperScope(symbol) => {
                assert_eq!(symbol.name, "var1")
            }
            SymbolError::NoScope => panic!(),
        },
    }

    // Insert var2
    let insert_result4 = table.insert(
        "var2",
        type_registry.lookup_type("int").unwrap().clone(),
        Location::new(0, 0, Span::new(0, 0), "-"),
        (),
    );

    // Expect to be ok
    match insert_result4 {
        Ok(_) => match table.lookup_symbol("var2") {
            Some(symbol) => assert_eq!(symbol.name, "var2"),
            None => panic!(),
        },
        Err(_) => panic!(),
    }
}

#[test]
fn current_module_name() {

    let mut table = SymbolTable::<()>::new();
    table.push_scope(SymbolScope::new(SymbolScopeType::Global));
    table.push_scope(SymbolScope::new(SymbolScopeType::Module("myModule".to_string())));
    table.push_scope(SymbolScope::new(SymbolScopeType::Function("myFunc".to_string())));

    assert!(table.current_module_name().is_some());
    assert_eq!(table.current_module_name().unwrap(), "myModule");
}
