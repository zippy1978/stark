use crate::code_gen::gen::test_util::{run_code};



#[test]
fn with_return() {
    assert!(run_code(
        r#"
        func test() => int {
            12
        }
        func main() => int {
            a: int
            a = test()
            0
        }
        "#,
    )
    .is_ok());
}

#[test]
fn assign_without_return() {
    assert!(run_code(
        r#"
        func test() {
        }
        func main() => int {
            a: int
            a = test()
            0
        }
        "#,
    )
    .is_err());
}

#[test]
fn with_params() {
    assert!(run_code(
        r#"
        func test(a: int, b: bool) {
        }
        func main() => int {
            a: int
            test(12, true)
            0
        }
        "#,
    )
    .is_ok());
}
