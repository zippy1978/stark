use std::ops::Range;

use codespan_reporting::diagnostic::{Diagnostic, Label};
use codespan_reporting::files::SimpleFiles;
use codespan_reporting::term;
use codespan_reporting::term::termcolor::{ColorChoice, StandardStream};
use lang::code_gen::CodeGenError;
use lang::parser::ParseError;
use lang::StarkError;

fn parse_error_diagnostic(file_id: usize, error: ParseError) -> Diagnostic<usize> {
    let range = Range {
        start: error.location.span().start(),
        end: error.location.span().end(),
    };

    let message = "parsing error";
    let label = match error.error {
        lang::parser::ParseErrorType::Eof => "EOF",
        lang::parser::ParseErrorType::ExtraToken(_) => "extra token",
        lang::parser::ParseErrorType::InvalidToken => "invalid token",
        lang::parser::ParseErrorType::UnrecognizedToken(_, _) => "unrecognized token",
        lang::parser::ParseErrorType::Lexical(_) => "syntax error",
    };

    Diagnostic::error()
        .with_message(message)
        //.with_code("XXX")
        .with_labels(vec![Label::primary(file_id, range).with_message(label)])
}

fn code_gen_error_diagnostic(file_id: usize, error: CodeGenError) -> Diagnostic<usize> {
    /*let range = Range {
        start: error.location.span().start(),
        end: error.location.span().end(),
    };


    let label = match error.error {
        lang::code_gen::CodeGenErrorType::Generic => "generic",
    };

    Diagnostic::error()
        .with_message(message)
        //.with_code("XXX")
        .with_labels(vec![Label::primary(file_id, range).with_message(label)])*/

    let message = "compile error";

    let mut diag = Diagnostic::error().with_message(message);

    print!("{}", error.logs.len());

    for log in &error.logs {
        let range = Range {
            start: log.location.span().start(),
            end: log.location.span().end(),
        };

        diag = diag.with_labels(vec![
            Label::primary(file_id, range).with_message(log.message)
        ]);
    }

    diag
}

pub fn report(name: &str, input: &str, error: StarkError) {
    let mut files = SimpleFiles::new();

    let file_id = files.add(name, input);

    let diagnostic = match error {
        StarkError::CodeGen(err) => code_gen_error_diagnostic(file_id, err),
        StarkError::Parser(err) => parse_error_diagnostic(file_id, err),
    };

    // We now set up the writer and configuration, and then finally render the
    // diagnostic to standard error.

    let writer = StandardStream::stderr(ColorChoice::Always);
    let config = codespan_reporting::term::Config::default();

    term::emit(&mut writer.lock(), &config, &files, &diagnostic);
}
