//! Compiler.
mod compiler;
pub use compiler::*;

mod error;
pub use error::*;

mod module;
pub use module::*;
#[cfg(test)]
mod module_tests;