use inkwell::{context::Context, memory_buffer::MemoryBuffer, module::Module};

use super::VirtualMachineError;

/// Expected entry point ("main") function signature.
type EntryFunction = unsafe extern "C" fn(i32, i32, i32) -> i32;

/// Masking of the inkwell usage
pub type OptimizationLevel = inkwell::OptimizationLevel;

/// Virtual machine configuration.
pub struct VirtualMachineConfig {
    optimization_level: OptimizationLevel,
}

impl VirtualMachineConfig {
    /// Creates a VM configuration.
    pub fn new(optimization_level: OptimizationLevel) -> Self {
        VirtualMachineConfig { optimization_level }
    }

    /// Created a default VM configuration.
    pub fn default() -> Self {
        VirtualMachineConfig { optimization_level: inkwell::OptimizationLevel::Default }
    }
}

/// Virtual machine.
/// Can run bitcode containing a "main" function
pub struct VirtualMachine {
    context: Context,
    config: VirtualMachineConfig,
}

impl VirtualMachine {
    /// Created a new VM instance.
    pub fn new(config: VirtualMachineConfig) -> Self {
        VirtualMachine {
            context: Context::create(),
            config,
        }
    }

    /// Runs bitcode from a MemoryBuffer.
    pub fn run_bitcode(&self, bitcode: &MemoryBuffer) -> Result<i32, VirtualMachineError> {
        match Module::parse_bitcode_from_buffer(bitcode, &self.context) {
            Ok(module) => match module.create_jit_execution_engine(self.config.optimization_level) {
                Ok(execution_engine) => unsafe {
                    let entry_function = execution_engine.get_function::<EntryFunction>("sum");
                    Result::Ok(entry_function.unwrap().call(1, 2, 3))
                },
                Err(err) => Result::Err(VirtualMachineError::JITEngine {
                    message: err.to_string(),
                }),
            },
            Err(err) => Result::Err(VirtualMachineError::Bitcode {
                message: err.to_string(),
            }),
        }
    }
}
