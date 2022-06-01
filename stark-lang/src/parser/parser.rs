lalrpop_mod!(stark, "/parser/stark.rs");
use std::{fs, path::PathBuf};

use super::{error::ParseError, lexer};
use crate::ast::{self, Location, Stmts, clone_stmts};
use lalrpop_util::lalrpop_mod;

/// Language parser.
pub struct Parser {}

impl Parser {
    /// Creates a new parser.
    pub fn new() -> Self {
        Parser {}
    }

    /// Parses input string to AST.
    pub fn parse(&self, filename: &str, input: &str) -> Result<ast::Stmts, ParseError> {
        let lexer = lexer::Lexer::new(&filename.to_string(), input);
        match stark::StmtsParser::new().parse(&filename.to_string(), lexer) {
            Ok(stmts) => return Result::Ok(stmts),
            Err(err) => return Result::Err(ParseError::from(err)),
        };
    }

    /// Parses file to AST.
    pub fn parse_file(&self, path: &PathBuf) -> Result<ast::Stmts, ParseError> {
        let filename = path.to_str().unwrap().to_string();
        match fs::read_to_string(path) {
            Ok(input) => self.parse(&filename, &input),
            Err(_) => Result::Err(ParseError {
                error_type: super::ParseErrorType::FileNotFound(filename.to_string()),
                location: Location::start(&filename),
            }),
        }
    }

    /// Parses files to a single AST.
    pub fn parse_files(&self, paths: &[PathBuf]) -> Result<ast::Stmts, ParseError> {
        let mut merged_asts = Stmts::new();
        for path in paths {
            match &self.parse_file(path) {
                Ok(ast) => merged_asts.append(&mut clone_stmts(ast)),
                Err(err) => return Result::Err(err.clone()),
            }
        };
        Result::Ok(merged_asts)
    }
}
