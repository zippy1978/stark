extern crate exitcode;

use std::fs;

use clap::Parser;
use stark_lang::{tools::Reporter, compiler::Compiler};

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
            Ok(output) => {
                reporter.report_logs(&filename, &input, output.logs);
                std::process::exit(exitcode::OK)
            }
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
