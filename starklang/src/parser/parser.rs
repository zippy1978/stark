lalrpop_mod!(stark, "/parser/stark.rs");
use super::{error::ParseError, lexer};
use crate::ast;
use lalrpop_util::lalrpop_mod;

/// Language parser.
pub struct Parser {}

impl Parser {
    /// Creates a new parser.
    pub fn new() -> Self {
        Parser {}
    }

    /// Parses input string to AST.
    pub fn parse(&self, input: &str) -> Result<ast::Unit, ParseError> {
        let filename = String::from("main");
        let lexer = lexer::Lexer::new(input);
        match stark::UnitParser::new().parse(&filename, lexer) {
            Ok(unit) => return Result::Ok(unit),
            Err(err) => return Result::Err(ParseError::from(err)),
        };
    }
}
