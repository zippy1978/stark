//! Type system.
//! 
//! Most important part of the module is dedicated to type checking.
//! Type checking is performed by the [TypeChecker].
//! During type checking the input AST is folded into a typed AST.
mod symbol;
pub(crate) use symbol::*;

mod symbol_table;
#[cfg(test)]
mod symbol_table_tests;
pub(crate) use symbol_table::*;

mod typing;
pub(crate) use typing::*;

mod check;

mod type_registry;
#[cfg(test)]
mod type_registry_tests;
pub(crate) use type_registry::*;

mod type_checker;
pub use type_checker::*;

mod error;
pub(crate) use error::*;
