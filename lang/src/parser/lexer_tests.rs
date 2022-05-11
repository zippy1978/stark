#[cfg(test)]
use logos::Logos;
use num_bigint::BigInt;

use crate::parser::Token;

#[test]
fn lexer() {
    let mut lex = Token::lexer("abc 123 \n");

    assert_eq!(lex.next(), Some(Token::Identifier(String::from("abc"))));
    assert_eq!(lex.span(), 0..3);
    assert_eq!(lex.slice(), "abc");

    assert_eq!(lex.next(), Some(Token::Integer(BigInt::from(123))));
    assert_eq!(lex.span(), 4..7);
    assert_eq!(lex.slice(), "123");

    assert_eq!(lex.next(), Some(Token::NewLine));
    assert_eq!(lex.span(), 8..9);
    assert_eq!(lex.slice(), "\n");

    assert_eq!(lex.next(), None);
}
