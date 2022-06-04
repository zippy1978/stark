use stark_lang::code_gen::run_code_in_main;

#[test]
fn integer() {
    assert!(run_code_in_main(
        r#"
        -12
        12
        0
        "#,
    )
    .is_ok());
}

#[test]
fn float() {
    assert!(run_code_in_main(
        r#"
        -1.23
        1.23
        0
        "#,
    )
    .is_ok());
}

#[test]
fn boolean() {
    assert!(run_code_in_main(
        r#"
        true
        false
        0
        "#,
    )
    .is_ok());
}
