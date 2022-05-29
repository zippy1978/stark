use crate::typing::check::test_util::type_check;

#[test]
fn new_function() {
    assert!(type_check(
        r#"
        func myFunc(a: int) => int {
            a
        }   
        "#
    )
    .is_ok());
}

#[test]
fn function_without_return() {
    assert!(type_check(
        r#"
        func noReturn(a: int) {
            a
        }    
        "#
    )
    .is_ok());
}

#[test]
fn already_defined_symbol() {
    assert!(type_check(
        r#"
        func test(a: int) {
            test: int
            a
        }    
        "#
    )
    .is_err());
}

#[test]
fn wrong_parameter_type() {
    assert!(type_check(
        r#"
        func wrongParam(a: undefined) => int {
            a
        }   
        "#
    )
    .is_err());
}

#[test]
fn wrong_return_type() {
    assert!(type_check(
        r#"
        func wrongReturn(a: int) => undefined {
            a
        }   
        "#
    )
    .is_err());
}

#[test]
fn parameter_shadowing() {
    assert!(type_check(
        r#"
        func shadowing(a: int) => int {
            a: float
        }   
        "#
    )
    .is_err());
}

#[test]
fn wrong_return_statement() {
    assert!(type_check(
        r#"
        func wrongReturnStmt(a: int) => int {
            b: float
            b
        }   
        "#
    )
    .is_err());
}

#[test]
fn nested_function() {
    assert!(type_check(
        r#"
        func nested() => int {
            func child() {
                
            }
        }   
        "#
    )
    .is_err());
}
