use crate::typing::check::test_util::{type_check};

#[test]
fn undefined() {
    assert!(type_check(
        r#"
        func main() {
            undefined(12)
        }
        "#
    )
    .is_err());
}

#[test]
fn not_callable() {
    assert!(type_check(
        r#"
        func main() {
            a: int
            a(12)
        }
        "#
    )
    .is_err());
}

#[test]
fn wrong_parameter_count() {
    assert!(type_check(
        r#"
        func test(a: int) => int {
            a
        }

        func main() {
            test(12, 2)
        }
        "#
    )
    .is_err());
}

#[test]
fn parameter_type_mismatch() {
    assert!(type_check(
        r#"
        func test(a: int) => int {
            a
        }

        func main() {
            test(true)
        }
        "#
    )
    .is_err());
}

#[test]
fn with_parameters() {
    assert!(type_check(
        r#"
        func test(a: int) => int {
            a
        }

        func main() {
            b: int
            b = test(12)
        }
        "#
    )
    .is_ok());
}

#[test]
fn without_return() {
    assert!(type_check(
        r#"
        func test(a: int) {
            
        }

        func main() {
            b: int
            b = test(12)
        }
        "#
    )
    .is_err());
}