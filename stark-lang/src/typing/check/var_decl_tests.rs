use crate::typing::check::test_util::{type_check, type_check_in_function};

#[test]
fn global_scope_declaration() {
    assert!(type_check("forbidden: int").is_err());
}

#[test]
fn existing_type() {
    assert!(type_check_in_function("a: int").is_ok());
}

#[test]
fn unknown_type() {
    assert!(type_check_in_function("a: unknown").is_err());
}

#[test]
fn already_defined() {
    assert!(type_check_in_function(
        r#"
        a: float
        a: int
        "#
    )
    .is_err());
}
