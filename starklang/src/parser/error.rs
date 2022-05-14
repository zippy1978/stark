//! Defines internal parse error types.
//! The goal is to provide a matching and a safe error API, maksing errors from LALR.
use lalrpop_util::ParseError as LalrpopError;

use super::token::Token;
use crate::ast::Location;

/// Represents an error during lexical scanning.
#[derive(Debug, PartialEq)]
pub struct LexicalError {
    pub location: Location,
}

/// Represents an error during parsing.
#[derive(Debug, PartialEq)]
pub struct ParseError {
    pub error_type: ParseErrorType,
    pub location: Location,
}

#[derive(Debug, PartialEq)]
pub enum ParseErrorType {
    /// Parser encountered an unexpected end of input.
    Eof,
    /// Parser encountered an extra Token.
    ExtraToken(Token),
    /// Parser encountered an invalid Token.
    InvalidToken,
    /// Parser encountered an unexpected Token.
    UnrecognizedToken(Token, Option<String>),
    /// Lexer error
    Lexical,
}

impl ToString for ParseError {
    fn to_string(&self) -> String {
        match &self.error_type {
            ParseErrorType::Eof => "unexpected end of input".to_string(),
            ParseErrorType::ExtraToken(token) => format!("extra token encountred `{}`", token),
            ParseErrorType::InvalidToken => "invalid token".to_string(),
            ParseErrorType::UnrecognizedToken(token, _value) => {
                format!("unrecognized token `{}`", token)
            }
            ParseErrorType::Lexical => "unknown token".to_string(),
        }
    }
}

/// Convert `lalrpop_util::ParseError` to internal type.
impl From<LalrpopError<Location, Token, LexicalError>> for ParseError {
    fn from(err: LalrpopError<Location, Token, LexicalError>) -> Self {
        match err {
            LalrpopError::InvalidToken { location } => ParseError {
                error_type: ParseErrorType::InvalidToken,
                location,
            },
            LalrpopError::ExtraToken { token } => ParseError {
                error_type: ParseErrorType::ExtraToken(token.1),
                location: token.0,
            },
            LalrpopError::User { error } => ParseError {
                error_type: ParseErrorType::Lexical,
                location: error.location,
            },
            LalrpopError::UnrecognizedToken { token, expected } => {
                let expected = if expected.len() == 1 {
                    Some(expected[0].clone())
                } else {
                    None
                };
                ParseError {
                    error_type: ParseErrorType::UnrecognizedToken(token.1, expected),
                    location: token.0,
                }
            }
            LalrpopError::UnrecognizedEOF { location, .. } => ParseError {
                error_type: ParseErrorType::Eof,
                location,
            },
        }
    }
}
