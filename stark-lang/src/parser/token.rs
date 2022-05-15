//! Lexer tokens.
use std::fmt::Display;

use logos::{Lexer, Logos};
use num_bigint::BigInt;

fn big_int(lex: &mut Lexer<Token>) -> Option<BigInt> {
    let n: u64 = lex.slice().parse().ok()?;
    Some(BigInt::from(n))
}

/// Lexer token.
#[derive(Logos, Clone, Debug, PartialEq)]
pub enum Token {
    #[regex(r"[_a-zA-Z][_0-9a-zA-Z]*", |lex| lex.slice().parse())]
    Identifier(String),

    #[regex(r"[0-9]+", big_int)]
    Integer(BigInt),

    #[token("\n")]
    NewLine,

    #[token(":")]
    Colon,

    #[token("=")]
    Equal,

    #[token("func")]
    Func,

    #[token("=>")]
    Arrow,

    #[token("(")]
    LParen,

    #[token(")")]
    RParen,

    #[token("{")]
    LBrace,

    #[token("}")]
    RBrace,

    // Skip spaces
    #[regex(r"[ \t\f]+", logos::skip)]
    // Skip single line comment
    #[regex(r"//[^\n\r]*[\n\r]*", logos::skip)]
    // Skip multiline comment
    #[regex(r"/\*[^*]*\*+(?:[^/*][^*]*\*+)*/", logos::skip)]
    #[error]
    Error,
}

impl Display for Token {
    
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let value_string;
        write!(
            f,
            "{}",
            match self {
                Token::Identifier(value) => value,
                Token::Integer(value) => {
                    value_string = value.to_string();
                    value_string.as_str()
                }
                Token::NewLine => "\n",
                Token::Colon => ":",
                Token::Equal => "=",
                Token::Error => "ERROR",
                Token::Func => "func",
                Token::Arrow => "=>",
                Token::LParen => "(",
                Token::RParen => ")",
                Token::LBrace => "{",
                Token::RBrace => "}",
            }
        )
    }
}
