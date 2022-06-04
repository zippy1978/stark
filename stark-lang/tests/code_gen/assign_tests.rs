use stark_lang::code_gen::run_code_in_main;

#[test]
fn integer() {
    assert!(run_code_in_main(
        r#"
        a: int
        a = 12
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
        a = 1.2
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
        a = true
        0
        "#,
    )
    .is_ok());
}
