use crate::typing::check::test_util::type_check_in_function;

#[test]
fn defined_symbol() {
    assert!(type_check_in_function(
        r#"
        defined: int
        defined
        "#
    )
    .is_ok());
}

#[test]
fn undefined_symbol() {
    assert!(type_check_in_function("undefined").is_err());
}
