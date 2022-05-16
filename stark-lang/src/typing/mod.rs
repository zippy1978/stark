mod symbol;
#[cfg(test)]
mod symbol_tests;
pub(crate) use symbol::*;

mod typing;
pub(crate) use typing::*;


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