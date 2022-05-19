//! Virtual Machine.
//! The VM is in charge of running (with JIT) bitcode.
mod virtual_machine;
pub use virtual_machine::*;

mod error;
pub use error::*;