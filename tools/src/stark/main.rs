extern crate exitcode;

use std::fs;

use clap::Parser;
use lang::{ast, parser, code_gen::Generator};
use tools::reporter::report;

#[derive(Parser, Debug)]
#[clap(name = "Stark compiler", author, version, about, long_about = None)]
struct Cli {
    #[clap(parse(from_os_str))]
    path: std::path::PathBuf,
}

fn main() {
    let args = Cli::parse();

    let mut generator = Generator::new();

    match fs::read_to_string(args.path) {
        Ok(input) => match parser::parse(&input) {
            Ok(unit) => generator.generate(&unit),
            Err(err) => {
                // TODO use nice reporter here !
                report(&input, err);
                std::process::exit(exitcode::USAGE);
            }
        },
        Err(err) => {
            println!("error: {}", err);
            std::process::exit(exitcode::NOINPUT);
        }
    }
}
