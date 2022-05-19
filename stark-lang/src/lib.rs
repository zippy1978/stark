//! Stark is a statically typed programming language.

pub mod compiler;
pub mod tools;
pub mod virtual_machine;

pub(crate) mod code_gen;
pub(crate) mod parser;
pub(crate) mod ast;
pub(crate) mod typing;
