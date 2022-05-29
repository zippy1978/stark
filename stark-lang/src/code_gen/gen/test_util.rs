use crate::{compiler::Compiler, virtual_machine::{VirtualMachine, VirtualMachineConfig}};

pub(crate) type RunCodeResult = Result<i32, String>;

pub(crate) fn run_code(input: &str) -> RunCodeResult {
    let compiler = Compiler::new();
    match compiler.compile_string(input) {
        Ok(output) => {
            let vm = VirtualMachine::new(VirtualMachineConfig::default());
            match vm.run_bitcode(&output.bitcode) {
                Ok(result) => Result::Ok(result),
                Err(_) => Result::Err("bitcode execution failed".to_string()),
            }
            
        },
        Err(_) => Result::Err("compilation failed".to_string()),
    }
}

pub(crate) fn run_code_in_main(input: &str) -> RunCodeResult {
    run_code(format!("func main() => int {{{}}}", input).as_str())
}