//! Define internal parse error types
//! The goal is to provide a matching and a safe error API, maksing errors from LALR
use lalrpop_util::ParseError as LalrpopError;

use super::token::Token;
use crate::ast::Location;

/// Represents an error during lexical scanning.
#[derive(Debug, PartialEq)]
pub struct LexicalError {
    pub error: LexicalErrorType,
    pub location: Location,
}

#[derive(Debug, PartialEq)]
pub enum LexicalErrorType {
    StringError,
    Eof,
    OtherError(String),
}

/// Represents an error during parsing
#[derive(Debug, PartialEq)]
pub struct ParseError {
    pub error: ParseErrorType,
    pub location: Location,
}

#[derive(Debug, PartialEq)]
pub enum ParseErrorType {
    /// Parser encountered an unexpected end of input
    Eof,
    /// Parser encountered an extra Token
    ExtraToken(Token),
    /// Parser encountered an invalid Token
    InvalidToken,
    /// Parser encountered an unexpected Token
    UnrecognizedToken(Token, Option<String>),
    /// Maps to `User` type from `lalrpop-util`
    Lexical(LexicalErrorType),
}

/// Convert `lalrpop_util::ParseError` to our internal type
impl From<LalrpopError<Location, Token, LexicalError>> for ParseError {
    fn from(err: LalrpopError<Location, Token, LexicalError>) -> Self {
        match err {
            LalrpopError::InvalidToken { location } => ParseError {
                error: ParseErrorType::InvalidToken,
                location,
            },
            LalrpopError::ExtraToken { token } => ParseError {
                error: ParseErrorType::ExtraToken(token.1),
                location: token.0,
            },
            LalrpopError::User { error } => ParseError {
                error: ParseErrorType::Lexical(error.error),
                location: error.location,
            },
            LalrpopError::UnrecognizedToken { token, expected } => {
                let expected = if expected.len() == 1 {
                    Some(expected[0].clone())
                } else {
                    None
                };
                ParseError {
                    error: ParseErrorType::UnrecognizedToken(token.1, expected),
                    location: token.0,
                }
            }
            LalrpopError::UnrecognizedEOF { location, .. } => ParseError {
                error: ParseErrorType::Eof,
                location,
            },
        }
    }
}
