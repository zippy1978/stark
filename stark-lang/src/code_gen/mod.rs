//! Code generation.
mod gen;

mod code_gen;
pub(crate) use code_gen::*;

mod util;
pub(crate) use util::*;

mod error;
pub(crate) use error::*;

mod mangler;
pub(crate) use mangler::*;
#[cfg(test)]
mod mangler_tests;

mod runtime;

mod test_util;
pub use test_util::*;
