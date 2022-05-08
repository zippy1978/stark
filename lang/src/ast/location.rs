//! Datatypes to support source location information.

use std::fmt;

#[derive(Clone, Copy, Debug, Default, PartialEq)]
pub struct Span {
    start: usize,
    end: usize,
}

impl Span {
    pub fn new(start: usize, end: usize) -> Self {
        Span { start, end }
    }

    pub fn start(&self) -> usize {
        self.start
    }

    pub fn end(&self) -> usize {
        self.end
    }
}
/// A location somewhere in the sourcecode.
#[derive(Clone, Copy, Debug, Default, PartialEq)]
pub struct Location {
    row: usize,
    column: usize,
    span: Span,
}

impl fmt::Display for Location {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "line {} column {}", self.row, self.column)
    }
}

impl Location {
    pub fn row(&self) -> usize {
        self.row
    }

    pub fn column(&self) -> usize {
        self.column
    }

    pub fn span(&self) -> Span {
        self.span
    }

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
            loc: *self,
            line,
            desc,
        }
    }
}

impl Location {
    pub fn new(row: usize, column: usize, span: Span) -> Self {
        Location { row, column, span }
    }
}
