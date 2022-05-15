extern crate exitcode;

use std::fs;

use clap::Parser;
use stark_lang::{
    compiler::Compiler,
    tools::Reporter,
    virtual_machine::{VirtualMachine, VirtualMachineError, VirtualMachineConfig},
};

#[derive(Parser, Debug)]
#[clap(name = "Stark compiler", author, version, about, long_about = None)]
struct Cli {
    #[clap(parse(from_os_str))]
    path: std::path::PathBuf,
}

fn main() {
    let args = Cli::parse();

    let filename = &args.path.to_str().unwrap();

    let reporter = Reporter::new();
    let compiler = Compiler::new();

    match fs::read_to_string(&args.path) {
        Ok(input) => match compiler.compile_string(&input) {
            Ok(output) => match output.bitcode {
                Some(bitcode) => {
                    let vm = VirtualMachine::new(VirtualMachineConfig::default());
                    match vm.run_bitcode(&bitcode) {
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
                // This should never happen !
                None => panic!(),
            },
            Err(err) => {
                reporter.report_logs(&filename, &input, err.logs);
                std::process::exit(exitcode::USAGE)
            }
        },
        Err(err) => {
            println!("error: {}", err);
            std::process::exit(exitcode::NOINPUT);
        }
    }
}
