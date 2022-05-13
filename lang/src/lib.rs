use code_gen::CodeGenError;
use parser::ParseError;

pub mod ast;
pub mod code_gen;
pub mod parser;

pub enum StarkError {
    CodeGen(CodeGenError),
    Parser(ParseError),
}
