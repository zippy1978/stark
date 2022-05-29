use crate::typing::check::test_util::{type_check};

#[test]
fn constants() {
    // Integer
    assert!(type_check("123").is_ok());
    // Negative integer
    assert!(type_check("-123").is_ok());
    // Float
    assert!(type_check("1.23").is_ok());
    // Negative float
    assert!(type_check("-1.23").is_ok());
    // Boolean true
    assert!(type_check("true").is_ok());
    // Boolean false
    assert!(type_check("false").is_ok());
}