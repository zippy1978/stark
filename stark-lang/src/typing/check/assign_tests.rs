use crate::typing::check::test_util::type_check_in_function;

#[test]
fn same_type() {
    assert!(type_check_in_function(
        r#"
        a: int
        a = 1
        "#
    )
    .is_ok());
}

#[test]
fn different_type() {
    // Different type
    assert!(type_check_in_function(
        r#"
        b: float
        b = 1
        "#
    )
    .is_err());
}
