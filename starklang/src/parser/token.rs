use std::fmt::Display;

use logos::{Lexer, Logos};
use num_bigint::BigInt;

fn big_int(lex: &mut Lexer<Token>) -> Option<BigInt> {
    let n: u64 = lex.slice().parse().ok()?;
    Some(BigInt::from(n))
}

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

    // Skip spaces
    #[regex(r"[ \t\f]+", logos::skip)]
    // Skip single line comment
    #[regex(r"//[^\n\r]*[\n\r]*", logos::skip)]
    // Skip multiline comment
    #[regex(r"/\*[^*]*\*+(?:[^/*][^*]*\*+)*/", logos::skip)]
    #[error]
    Error, // requis pour tout les tokens invalides
}

impl Display for Token {
    // TODO : fix display here
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}]",
            match self {
                Token::Identifier(value) => value,
                Token::Integer(value) => "TODO === INT",
                Token::NewLine => "\n",
                Token::Colon => ":",
                Token::Equal => "=",
                Token::Error => "ERROR",
            }
        )
    }
}
