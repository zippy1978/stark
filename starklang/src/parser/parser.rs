lalrpop_mod!(stark, "/parser/stark.rs");
use super::{error::ParseError, lexer};
use crate::ast;
use lalrpop_util::lalrpop_mod;

/// Language parser.
pub struct Parser {}

impl Parser {
    /// Parses input string to AST
    pub fn parse(input: &str) -> Result<ast::Unit, ParseError> {
        let filename = String::from("main");
        let lexer = lexer::Lexer::new(input);
        match stark::UnitParser::new().parse(&filename, lexer) {
            Ok(unit) => return Result::Ok(unit),
            Err(err) => return Result::Err(ParseError::from(err)),
        };
    }
}

