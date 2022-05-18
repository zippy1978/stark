use crate::{ast, parser::Parser};

use super::{TypeChecker, TypeCheckerContext, TypeRegistry};

fn ast_from(input: &str) -> ast::Stmts {
    let parser = Parser::new();
    parser.parse(input).unwrap()
}

#[test]
fn type_check_expr_constants() {
    let mut type_checker = TypeChecker::new();
    let mut type_registry = TypeRegistry::new();
    let mut context = TypeCheckerContext::new(&mut type_registry);

    // Integer
    assert!(type_checker
        .check(&ast_from("123"), &mut context)
        .is_ok());

}

#[test]
fn type_check_expr_name() {
    let mut type_checker = TypeChecker::new();
    let mut type_registry = TypeRegistry::new();
    let mut context = TypeCheckerContext::new(&mut type_registry);

    // Undefined symbol
    assert!(type_checker
        .check(&ast_from("abc"), &mut context)
        .is_err());

}
