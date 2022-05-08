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

    #[regex(r"[ \t\f]+", logos::skip)]
    #[error]
    Error, // requis pour tout les tokens invalides
}
