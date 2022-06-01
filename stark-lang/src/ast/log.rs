use crate::ast::Location;

pub struct Logger {
    logs: Vec<Log>,
}

impl Logger {
    pub fn new() -> Logger {
        Logger { logs: Vec::new() }
    }

    pub fn add(&mut self, log: Log) {
        self.logs.push(log);
    }

    pub fn logs(&self) -> Vec<Log> {
        self.logs.to_vec()
    }

    pub fn clear(&mut self) {
        self.logs.clear()
    }

    pub fn has_error(&self) -> bool {
        self.logs.iter().any(|log| match &log.level {
            LogLevel::Warning => false,
            LogLevel::Error => true,
        })
    }
}

/// A message somewhere in the source code.
#[derive(Debug, PartialEq, Clone)]
pub struct LoglLabel {
    pub message: String,
    pub location: Location,
}

impl LoglLabel {
    pub fn new(message: impl Into<String>, location: Location) -> Self {
        LoglLabel {
            message: message.into(),
            location,
        }
    }
}

/// A log message.
#[derive(Debug, PartialEq)]
pub struct Log {
    pub filename: String,
    pub message: String,
    pub level: LogLevel,
    pub labels: Vec<LoglLabel>,
}

impl Log {
    pub fn new(filename: impl Into<String>, message: impl Into<String>, level: LogLevel) -> Self {
        Log {
            filename: filename.into(),
            message: message.into(),
            level,
            labels: Vec::new(),
        }
    }

    pub fn with_label(mut self, message: impl Into<String>, location: Location) -> Self {
        self.labels.push(LoglLabel {
            message: message.into(),
            location,
        });
        self
    }

    pub fn new_with_single_label(
        filename: impl Into<String>,
        message: impl Into<String>,
        level: LogLevel,
        location: Location,
    ) -> Self {
        let msg: String = message.into();
        Self::new(filename.into(), msg.clone(), level).with_label(msg, location)
    }
}

impl Clone for Log {
    fn clone(&self) -> Self {
        Self {
            filename: self.filename.clone(),
            level: self.level.clone(),
            message: self.message.clone(),
            labels: self.labels.to_vec(),
        }
    }
}

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum LogLevel {
    Warning,
    Error,
}
