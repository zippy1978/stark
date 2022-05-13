use inkwell::context::Context;

use crate::ast::{Location, Span};
#[cfg(test)]
use crate::code_gen::{
    self,
    symbol::{SymbolScope, SymbolScopeType, SymbolTable},
    typing::Type,
};

use super::{
    typing::{TypeKind, TypeRegistry}, 
};

fn table_with_scope<'a>() -> SymbolTable<'a> {
    let mut table = SymbolTable::new();
    table.push_scope(SymbolScope::new(SymbolScopeType::Global));
    table
}

#[test]
fn push_scope() {
    let mut table = SymbolTable::new();

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
    let mut table = SymbolTable::new();
    table.push_scope(SymbolScope::new(SymbolScopeType::Global));
    table.pop_scope();

    match table.current_scope() {
        Some(_) => panic!(),
        None => assert!(true),
    }
}

#[test]
fn lookup_symbol<'a>() {
    let context = Context::create();
    let mut type_registry = TypeRegistry::new();
    type_registry.insert("int", TypeKind::Primary, context.i64_type(), None);
    let mut table = SymbolTable::new();
    table.push_scope(SymbolScope::new(SymbolScopeType::Global));

    // Insert var1
    let insert_result1 = table.insert(
        "var1",
        type_registry.lookup_type("int").unwrap(),
        Location::new(0, 0, Span::new(0, 0)),
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
        type_registry.lookup_type("int").unwrap(),
        Location::new(0, 0, Span::new(0, 0)),
    );

    // Expect to be error
    match insert_result2 {
        Ok(_) => panic!(),

        Err(err) => match err {
            code_gen::symbol::SymbolError::AlreadyDefined(symbol) => {
                assert_eq!(symbol.name, "var1")
            }
            code_gen::symbol::SymbolError::AlreadyDefinedInUpperScope(_) => panic!(),
            code_gen::symbol::SymbolError::NoScope => panic!(),
        },
    }

    // Push a seconde scope
    table.push_scope(SymbolScope::new(SymbolScopeType::Global));

    // Insert var1 a third time
    let insert_result3 = table.insert(
        "var1",
        type_registry.lookup_type("int").unwrap(),
        Location::new(0, 0, Span::new(0, 0)),
    );

    // Expect to be error
    match insert_result3 {
        Ok(_) => panic!(),

        Err(err) => match err {
            code_gen::symbol::SymbolError::AlreadyDefined(_) => panic!(),
            code_gen::symbol::SymbolError::AlreadyDefinedInUpperScope(symbol) => {
                assert_eq!(symbol.name, "var1")
            }
            code_gen::symbol::SymbolError::NoScope => panic!(),
        },
    }

    // Insert var2
    let insert_result4 = table.insert(
        "var2",
        type_registry.lookup_type("int").unwrap(),
        Location::new(0, 0, Span::new(0, 0)),
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
