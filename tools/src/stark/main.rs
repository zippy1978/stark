extern crate exitcode;

use std::fs;

use clap::Parser;
use lang::{ast, parser};
use tools::reporter::report;

#[derive(Parser)]
struct Cli {
    #[clap(parse(from_os_str))]
    path: std::path::PathBuf,
}

/*
fn print_ast(root: &ast::Unit) {
    let unit_iter = root.iter();
    for s in unit_iter {
        match &s.node {
            ast::StmtKind::Assign => println!("It is assign !"),
            ast::StmtKind::Expr { value } => match &value.node {
                ast::ExprKind::Name { id } => println!("It's an id = <{}>", id.as_str()),
                _ => println!("not yet !"),
            },
            _ => println!("not yet !"),
        }
    }
} */

fn main() {
    let args = Cli::parse();

    match fs::read_to_string(args.path) {
        Ok(input) => match parser::parse(&input) {
            Ok(unit) => println!("{:?}", &unit),
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
