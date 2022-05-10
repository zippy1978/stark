use crate::ast::Location;

pub struct Logger<'a> {
    logs: Vec<Log<'a>>,
}

impl<'a> Logger<'a> {
    pub fn new() -> Logger<'a> {
        Logger { logs: Vec::new() }
    }

    pub fn add(&mut self, log: Log<'a>) {
        self.logs.push(log);
    }

    pub fn logs(&self) -> Vec<Log> {
        self.logs.to_vec()
    }
}

#[derive(Debug, PartialEq)]
pub struct Log<'a> {
    pub location: Location,
    pub level: LogLevel,
    pub message: &'a str,
}

impl<'a> Clone for Log<'a> {
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
