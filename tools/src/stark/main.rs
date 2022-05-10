extern crate exitcode;

use std::{fs, task::Context};

use clap::Parser;
use lang::{ast, code_gen, parser};
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
    let context = code_gen::Context::create();
    let mut generator = code_gen::Generator::new(&context, code_gen::Config::new(&filename));

    match fs::read_to_string(&args.path) {
        Ok(input) => match parser::parse(&input) {
            Ok(unit) => match generator.generate(&unit) {
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
