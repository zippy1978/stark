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
    assert!(type_checker.check(&ast_from("123"), &mut context).is_ok());
}

#[test]
fn type_check_expr_name() {
    let mut type_checker = TypeChecker::new();
    let mut type_registry = TypeRegistry::new();
    let mut context = TypeCheckerContext::new(&mut type_registry);

    // Defined symbol
    assert!(type_checker
        .check(
            &ast_from(
                r#"
            defined: int
            defined
        "#
            ),
            &mut context
        )
        .is_ok());

    // Undefined symbol
    assert!(type_checker
        .check(&ast_from("undefined"), &mut context)
        .is_err());
}

#[test]
fn type_check_var_decl() {
    let mut type_checker = TypeChecker::new();
    let mut type_registry = TypeRegistry::new();
    let mut context = TypeCheckerContext::new(&mut type_registry);

    // Existing type
    assert!(type_checker
        .check(&ast_from("a: int"), &mut context)
        .is_ok());

    // Unknown type
    assert!(type_checker
        .check(&ast_from("a: unknown"), &mut context)
        .is_err());

    // Already defined
    assert!(type_checker
        .check(&ast_from("a: int"), &mut context)
        .is_err());
}

#[test]
fn type_check_assign() {
    let mut type_checker = TypeChecker::new();
    let mut type_registry = TypeRegistry::new();
    let mut context = TypeCheckerContext::new(&mut type_registry);

    // Same type
    assert!(type_checker
        .check(
            &ast_from(
                r#"
        a: int
        a = 1"#
            ),
            &mut context
        )
        .is_ok());

    // Diffrent type
    assert!(type_checker
        .check(
            &ast_from(
                r#"
        b: float
        b = 1"#
            ),
            &mut context
        )
        .is_err());
}
