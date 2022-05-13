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
}

#[derive(Debug, PartialEq)]
pub struct Log {
    pub location: Location,
    pub level: LogLevel,
    pub message: String,
}

impl<'a> Clone for Log {
    fn clone(&self) -> Self {
        Self {
            location: self.location.clone(),
            level: self.level.clone(),
            message: self.message.clone(),
        }
    }
}

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum LogLevel {
    Warning,
    Error,
}
