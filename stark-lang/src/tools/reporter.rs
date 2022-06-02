use std::fs;
use std::path::PathBuf;

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

    fn diag_from_log(file_id: usize, log: &Log) -> Diagnostic<usize> {
        let diag: Diagnostic<usize> = match log.level {
            LogLevel::Warning => Diagnostic::warning().with_message(log.message.clone()),
            LogLevel::Error => Diagnostic::error().with_message(log.message.clone()),
        };

        let mut labels = Vec::<Label<usize>>::new();
        for label in &log.labels {
            labels.push(
                Label::primary(file_id, label.location.span.to_range())
                    .with_message(label.message.clone()),
            );
        }

        diag.with_labels(labels)
    }

    pub fn report_logs_for_files(&self, paths: &[PathBuf], logs: Vec<Log>) {
        let mut files = SimpleFiles::new();

        // Collect source files content
        for path in paths {
            match fs::read_to_string(path) {
                Ok(source) => {
                    files.add(path.to_str().unwrap(), source);
                }
                Err(_) => (),
            };
        }

        let writer = StandardStream::stderr(ColorChoice::Always);
        let config = codespan_reporting::term::Config::default();

        // Report logs by file
        for (i, path) in paths.iter().enumerate() {
            let file_logs = logs
                .iter()
                .filter(|&log| log.filename == path.to_str().unwrap())
                .collect::<Vec<&Log>>();

            for log in file_logs {
                let diag = Self::diag_from_log(i, log);
                match term::emit(&mut writer.lock(), &config, &files, &diag) {
                    Ok(_) => (),
                    Err(err) => println!("{}: {}", path.to_str().unwrap(), err),
                };
            }
        }
    }
}
