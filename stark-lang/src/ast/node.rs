use super::Constant;
use super::Location;

type Ident = String;

#[derive(Debug, PartialEq)]
pub struct Located<T> {
    pub location: Location,
    pub node: T,
}

impl<T> Located<T> {
    pub fn new(location: Location, node: T) -> Self {
        Self {
            location,
            node,
        }
    }
}

#[derive(Debug, PartialEq)]
pub struct Arg {
    pub name: Ident,
    pub var_type: Ident,
}

pub type Arguments = Located<Vec<Arg>>;

#[derive(Debug, PartialEq)]
pub enum StmtKind {
    Expr {
        value: Box<Expr>,
    },
    VarDef {
        name: Ident,
        var_type: Ident,
    },
    Assign {
        target: Box<Expr>,
        value: Box<Expr>,
    },
    FunctionDef {
        name: Ident,
        args: Box<Arguments>,
        body: Vec<Stmt>,
        returns: Option<Ident>,
    },
}
pub type Stmt = Located<StmtKind>;

#[derive(Debug, PartialEq)]
pub enum ExprKind<U = ()> {
    Mock { m: U }, // Remove someday...
    Name { id: Ident },
    Constant { value: Constant },
}
pub type Expr = Located<ExprKind>;

pub type Stmts = Vec<Stmt>;

// Notes
// Use https://github.com/brendanzab/codespan
