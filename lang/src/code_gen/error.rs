use super::Log;

#[derive(Debug, PartialEq)]
pub struct CodeGenError<'a> {
    pub logs: Vec<Log<'a>>,
}
