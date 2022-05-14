use std::ops::Range;

use codespan_reporting::diagnostic::{Diagnostic, Label};
use codespan_reporting::files::SimpleFiles;
use codespan_reporting::term;
use codespan_reporting::term::termcolor::{ColorChoice, StandardStream};

use crate::ast::{Log, LogLevel};

/// Reporter: outputs readable warnings and errors
pub struct Reporter {}

impl Reporter {

    pub fn new() -> Self {
        Reporter {}
    }
    
    fn diag_from_log(file_id: usize, log: Log) -> Diagnostic<usize> {
        let diag: Diagnostic<usize> = match log.level {
            LogLevel::Warning => Diagnostic::warning().with_message(log.message),
            LogLevel::Error => Diagnostic::error().with_message(log.message),
        };

        let mut labels = Vec::<Label<usize>>::new();
        for label in log.labels {
            let range = Range {
                start: label.location.span().start(),
                end: label.location.span().end(),
            };
            labels.push(Label::primary(file_id, range).with_message(label.message));
        }

        diag.with_labels(labels)
    }

    /// TODO
    pub fn report_logs(&self, name: &str, source: &str, logs: Vec<Log>) {
        let mut files = SimpleFiles::new();
        let file_id = files.add(name, source);

        let writer = StandardStream::stderr(ColorChoice::Always);
        let config = codespan_reporting::term::Config::default();

        for log in logs {
            let diag = Self::diag_from_log(file_id, log);
            term::emit(&mut writer.lock(), &config, &files, &diag);
        }
    }
}
