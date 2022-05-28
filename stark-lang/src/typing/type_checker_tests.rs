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
            func definedSymbol() {
                defined: int
                defined
            }
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

    // Global scope declaration is forbidden
    assert!(type_checker
        .check(&ast_from("forbidden: int"), &mut context)
        .is_err());

    // Existing type
    assert!(type_checker
        .check(
            &ast_from(
                r#"
        func existingType() {
            a: int
        }
        "#
            ),
            &mut context
        )
        .is_ok());

    // Unknown type
    assert!(type_checker
        .check(
            &ast_from(
                r#"
        func unknownType() {
            a: unknown
        }
        "#
            ),
            &mut context
        )
        .is_err());

    // Already defined
    assert!(type_checker
        .check(
            &ast_from(
                r#"
        func alreadyDefined() {
            a: float
            a: int
        }
        "#
            ),
            &mut context
        )
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
        func sameType() {
            a: int
            a = 1
        }"#
            ),
            &mut context
        )
        .is_ok());

    // Different type
    assert!(type_checker
        .check(
            &ast_from(
                r#"
        func diffType() {
            b: float
            b = 1
        }"#
            ),
            &mut context
        )
        .is_err());
}

#[test]
fn type_check_func_def() {
    let mut type_checker = TypeChecker::new();
    let mut type_registry = TypeRegistry::new();
    let mut context = TypeCheckerContext::new(&mut type_registry);

    // New function
    assert!(type_checker
        .check(
            &ast_from(
                r#"
        func myFunc(a: int) => int {
            a
        }   
            "#
            ),
            &mut context
        )
        .is_ok());

    // Function wihtout return
    assert!(type_checker
        .check(
            &ast_from(
                r#"
        func noReturn(a: int) {
            a
        }   
            "#
            ),
            &mut context
        )
        .is_ok());

    // Already defined symbol
    assert!(type_checker
        .check(
            &ast_from(
                r#"
        alreadyDefined: int
        func alreadyDefined(a: int) => int {
            a
        }   
            "#
            ),
            &mut context
        )
        .is_err());

    // Wrong parameter type
    assert!(type_checker
        .check(
            &ast_from(
                r#"
            func wrongParam(a: undefined) => int {
                a
            }   
                "#
            ),
            &mut context
        )
        .is_err());

    // Wrong return type
    assert!(type_checker
        .check(
            &ast_from(
                r#"
            func wrongReturn(a: int) => undefined {
                a
            }   
                "#
            ),
            &mut context
        )
        .is_err());

    // Parameter shadowing
    assert!(type_checker
        .check(
            &ast_from(
                r#"
            func shadowing(a: int) => int {
                a: float
            }   
                "#
            ),
            &mut context
        )
        .is_err());

    // Wrong return statment
    assert!(type_checker
        .check(
            &ast_from(
                r#"
            func wrongReturnStmt(a: int) => int {
                b: float
                b
            }   
                "#
            ),
            &mut context
        )
        .is_err());

    // Function into function is forbidden
    assert!(type_checker
        .check(
            &ast_from(
                r#"
            func nested() => int {
                func child() {
                    
                }
            }   
                "#
            ),
            &mut context
        )
        .is_err());
}
