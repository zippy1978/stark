use code_gen::CodeGenError;
use parser::ParseError;

pub mod ast;
pub mod code_gen;
pub mod parser;

pub enum StarkError<'a> {
    CodeGen(CodeGenError<'a>),
    Parser(ParseError),
}
