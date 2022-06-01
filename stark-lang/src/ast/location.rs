//! Datatypes to support source location information.

use std::{fmt, ops::Range};

#[derive(Clone, Copy, Debug, Default, PartialEq)]
pub struct Span {
    pub(crate) start: usize,
    pub(crate) end: usize,
}

/// A span.
impl Span {
    pub fn new(start: usize, end: usize) -> Self {
        Span { start, end }
    }

    pub fn to_range(&self) -> Range<usize> {
        Range {
            start: self.start,
            end: self.end,
        }
    }
}

/// A location somewhere in the sourcecode.
#[derive(Debug, Default, PartialEq)]
pub struct Location {
    pub(crate) row: usize,
    pub(crate) column: usize,
    pub(crate) span: Span,
    pub(crate) filename: String,
}

impl Clone for Location {
    fn clone(&self) -> Self {
        Self {
            row: self.row.clone(),
            column: self.column.clone(),
            span: self.span.clone(),
            filename: self.filename.clone(),
        }
    }
}

impl fmt::Display for Location {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "line {} column {}", self.row, self.column)
    }
}

impl Location {
    pub fn visualize<'a>(
        &self,
        line: &'a str,
        desc: impl fmt::Display + 'a,
    ) -> impl fmt::Display + 'a {
        struct Visualize<'a, D: fmt::Display> {
            loc: Location,
            line: &'a str,
            desc: D,
        }
        impl<D: fmt::Display> fmt::Display for Visualize<'_, D> {
            fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
                write!(
                    f,
                    "{}\n{}{arrow:>pad$}",
                    self.desc,
                    self.line,
                    pad = self.loc.column,
                    arrow = "^",
                )
            }
        }
        Visualize {
            loc: self.clone(),
            line,
            desc,
        }
    }
}

impl Location {
    pub fn new(row: usize, column: usize, span: Span, filename: &str) -> Self {
        Location {
            row,
            column,
            span,
            filename: filename.to_string(),
        }
    }

    pub fn start(filename: &str) -> Self {
        Location {
            row: 0,
            column: 0,
            span: Span::new(0, 0),
            filename: filename.to_string(),
        }
    }
}
