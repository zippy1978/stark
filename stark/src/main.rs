extern crate exitcode;

use std::fs;

use clap::Parser;
use starklang::{compiler::Compiler, tools::Reporter};

#[derive(Parser, Debug)]
#[clap(name = "Stark compiler", author, version, about, long_about = None)]
struct Cli {
    #[clap(parse(from_os_str))]
    path: std::path::PathBuf,
}

fn main() {
    let args = Cli::parse();

    let filename = &args.path.to_str().unwrap();

    match fs::read_to_string(&args.path) {
        Ok(input) => match Compiler::from_string(&input) {
            Ok(output) => {
                Reporter::report_logs(&filename, &input, output.logs);
                std::process::exit(exitcode::OK)
            }
            Err(err) => {
                Reporter::report_logs(&filename, &input, err.logs);
                std::process::exit(exitcode::USAGE)
            }
        },
        Err(err) => {
            println!("error: {}", err);
            std::process::exit(exitcode::NOINPUT);
        }
    }
}
