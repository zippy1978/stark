extern crate exitcode;

use clap::Parser;
use stark_lang::{
    compiler::Compiler,
    tools::Reporter,
    virtual_machine::{VirtualMachine, VirtualMachineConfig, VirtualMachineError},
};

#[derive(Parser, Debug)]
#[clap(author, version, about, long_about = None)]
struct Cli {
    #[clap(parse(from_os_str))]
    inputs: Vec<std::path::PathBuf>,
}

fn main() {
    let args = Cli::parse();

    let inputs = &args.inputs;

    let reporter = Reporter::new();
    let compiler = Compiler::new();

    match compiler.compile_files(inputs) {
        Ok(output) => {
            let vm = VirtualMachine::new(VirtualMachineConfig::default());
            match vm.run_bitcode(&output.bitcode) {
                Ok(result) => std::process::exit(result),
                Err(err) => {
                    match err {
                        VirtualMachineError::Bitcode { message } => {
                            println!("error: {}", message)
                        }
                        VirtualMachineError::JITEngine { message } => {
                            println!("error: {}", message)
                        }
                    };
                    std::process::exit(exitcode::NOINPUT);
                }
            }
        }
        Err(err) => {
            reporter.report_logs_for_files(inputs, err.logs);
            std::process::exit(exitcode::USAGE)
        }
    }
}
