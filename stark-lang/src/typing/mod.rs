//! Type system.
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
pub(crate) use type_checker::*;
#[cfg(test)]
mod type_checker_tests;

mod error;
pub(crate) use error::*;