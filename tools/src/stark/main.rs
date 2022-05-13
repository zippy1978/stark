extern crate exitcode;

use std::{fs,};

use clap::Parser;
use lang::{ast, code_gen::{self, CodeGen}, parser};
use tools::reporter::report;

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
        Ok(input) => match parser::parse(&input) {
            Ok(unit) => match CodeGen::from_ast(&unit) {
                Ok(_) => std::process::exit(exitcode::OK),
                Err(err) => {
                    report(&filename, &input, lang::StarkError::CodeGen(err));
                    std::process::exit(exitcode::USAGE);
                }
            },
            Err(err) => {
                report(&filename, &input, lang::StarkError::Parser(err));
                std::process::exit(exitcode::USAGE);
            }
        },
        Err(err) => {
            println!("error: {}", err);
            std::process::exit(exitcode::NOINPUT);
        }
    }
}
