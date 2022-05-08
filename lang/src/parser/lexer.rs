use crate::ast::{Location, Span};

use super::error::{LexicalError, LexicalErrorType};
use super::token::Token;
use logos::{Logos, SpannedIter};

pub type Spanned<Tok, Loc, Error> = Result<(Loc, Tok, Loc), Error>;

pub struct Lexer<'input> {
    filename: String,
    token_stream: SpannedIter<'input, Token>,
    row_no: usize,
    column_no: usize,
    line_start: usize,
}

impl<'input> Lexer<'input> {
    pub fn new(filename: &String, input: &'input str) -> Self {
        Self {
            filename: filename.clone(),
            token_stream: Token::lexer(input).spanned(),
            row_no: 0,
            column_no: 0,
            line_start: 0,
        }
    }
}

impl<'input> Iterator for Lexer<'input> {
    type Item = Spanned<Token, Location, LexicalError>;
    fn next(&mut self) -> Option<Self::Item> {
        match self.token_stream.next() {
            None => None,
            Some((token, span)) => {
                let location = Location::new(
                    self.row_no,
                    span.start - self.line_start,
                    Span::new(span.start, span.end),
                );
                match token {
                    /*Token::Error => Some(Err(LexicalError {
                        error: LexicalErrorType::Eof,
                        location: location,
                    })),*/
                    Token::NewLine => {
                        self.row_no += 1;
                        self.column_no = 0;
                        self.line_start = span.start;
                        return Some(Ok((location, token, location)));
                    }
                    _ => Some(Ok((location, token, location))),
                }
            }
        }
    }
}
