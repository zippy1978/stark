use crate::code_gen::gen::test_util::{run_code_in_main, run_code};

#[test]
fn variable() {
    assert!(run_code_in_main(
        r#"
        a: int
        a = 0
        a
        "#,
    )
    .is_ok());
}

#[test]
fn function() {
    assert!(run_code(
        r#"
        func test() {

        }

        func main() => int {
            test
            0
        }
        "#,
    )
    .is_ok());
}
