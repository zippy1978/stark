use crate::{ast, parser::Parser};

use super::{TypeChecker, TypeCheckerContext, TypeRegistry};

fn ast_from(input: &str) -> ast::Stmts {
    let parser = Parser::new();
    parser.parse(input).unwrap()
}

#[test]
fn type_check_assign() {
    let mut type_checker = TypeChecker::new();
    let mut type_registry = TypeRegistry::new();
    let mut context = TypeCheckerContext::new(&mut type_registry);

    assert!(type_checker
        .check(&ast_from("a: int"), &mut context)
        .is_ok());
    assert!(type_checker
        .check(&ast_from("a: unknown"), &mut context)
        .is_err());
}
