use stark_lang::code_gen::run_code_in_main;

#[test]
fn stmts() {
    assert!(run_code_in_main(
        r#"
        a: int
        a = 1
        b: float
        b = 1.2
        c: bool
        c = false
        0
        "#,
    )
    .is_ok());
}
