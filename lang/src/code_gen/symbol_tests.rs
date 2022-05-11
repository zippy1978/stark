use crate::ast::{Location, Span};
#[cfg(test)]
use crate::code_gen::{
    self,
    symbol::{SymbolScope, SymbolScopeType, SymbolTable},
    typing::Type,
};

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
fn symbol_lookup() {
    let context = code_gen::Context::create();

    let mut table = SymbolTable::new();
    table.push_scope(SymbolScope::new(SymbolScopeType::Global));

    match table.current_scope_mut() {
        Some(scope) => {
            scope.insert(
                &"my_var".to_string(),
                Type::Primary {
                    name: "int",
                    llvm_type: context.i64_type(),
                },
                Location::new(0, 0, Span::new(0, 0))
            );

            match scope.lookup_symbol("my_var") {
                Some(symbol) => {
                    assert_eq!(symbol.name, "my_var");
                }
                None => panic!(),
            }
        }
        None => panic!(),
    }
}
