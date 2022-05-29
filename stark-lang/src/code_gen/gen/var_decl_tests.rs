use crate::code_gen::gen::test_util::run_code_in_main;

#[test]
fn integer() {
    assert!(run_code_in_main(
        r#"
        a: int
        0
        "#,
    )
    .is_ok());
}

#[test]
fn float() {
    assert!(run_code_in_main(
        r#"
        a: float
        0
        "#,
    )
    .is_ok());
}

#[test]
fn boolean() {
    assert!(run_code_in_main(
        r#"
        a: bool
        0
        "#,
    )
    .is_ok());
}
