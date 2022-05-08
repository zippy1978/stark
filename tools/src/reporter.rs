use std::ops::Range;

use codespan_reporting::diagnostic::{Diagnostic, Label};
use codespan_reporting::files::SimpleFiles;
use codespan_reporting::term;
use codespan_reporting::term::termcolor::{ColorChoice, StandardStream};
use lang::parser::ParseError;

pub fn report(input: &str, error: ParseError) {
    let mut files = SimpleFiles::new();

    let file_id = files.add("toto", input);

    // We normally recommend creating a custom diagnostic data type for your
    // application, and then converting that to `codespan-reporting`'s diagnostic
    // type, but for the sake of this example we construct it directly.

    let range = Range {
        start: error.location.span().start(),
        end: error.location.span().end(),
    };

    // TODO : implement Display trait on error instead
    let message = "parsing error";
    let label = match error.error {
        lang::parser::ParseErrorType::Eof => "EOF",
        lang::parser::ParseErrorType::ExtraToken(_) => "extra token",
        lang::parser::ParseErrorType::InvalidToken => "invalid token",
        lang::parser::ParseErrorType::UnrecognizedToken(_, _) => "unrecognized token",
        lang::parser::ParseErrorType::Lexical(_) => "syntax error",
    };

    let diagnostic = Diagnostic::error()
        .with_message(message)
        //.with_code("XXX")
        .with_labels(vec![
            Label::primary(file_id, range ).with_message(label),
        ])
       /*  .with_notes(vec![unindent::unindent(
            "
            expected type `String`
                found type `Nat`
        ",
        )])*/;

    // We now set up the writer and configuration, and then finally render the
    // diagnostic to standard error.

    let writer = StandardStream::stderr(ColorChoice::Always);
    let config = codespan_reporting::term::Config::default();

    term::emit(&mut writer.lock(), &config, &files, &diagnostic);
}
