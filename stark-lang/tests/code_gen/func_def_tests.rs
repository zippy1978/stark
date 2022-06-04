use stark_lang::code_gen::run_code;

#[test]
fn no_param() {
    assert!(run_code(
        r#"

        func test() {

        }

        func main() => int {
            0
        }
        "#,
    )
    .is_ok());
}

#[test]
fn no_return() {
    assert!(run_code(
        r#"

        func test(a: int) {

        }

        func main() => int {
            0
        }
        "#,
    )
    .is_ok());
}

#[test]
fn with_params() {
    assert!(run_code(
        r#"

        func test(a: int, b: float, c: bool) {
            a
            b
            c
        }

        func main() => int {
            0
        }
        "#,
    )
    .is_ok());
}

#[test]
fn with_return() {
    assert!(run_code(
        r#"

        func test(a: int) => int {
            a
        }

        func main() => int {
            0
        }
        "#,
    )
    .is_ok());
}
