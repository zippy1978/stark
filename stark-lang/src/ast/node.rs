use super::Constant;
use super::Location;

type Ident = String;

#[derive(Debug, PartialEq)]
pub struct Located<T, U = ()> {
    pub location: Location,
    pub custom: U,
    pub node: T,
}

impl<T> Located<T> {
    pub fn new(location: Location, node: T) -> Self {
        Self {
            location,
            custom: (),
            node,
        }
    }
}

#[derive(Debug, PartialEq)]
pub enum StmtKind<U = ()> {
    Expr {
        value: Box<Expr<U>>,
    },
    VarDef {
        variable: Ident,
        var_type: Ident,
    },
    Assign {
        target: Box<Expr<U>>,
        value: Box<Expr<U>>,
    },
}
pub type Stmt<U = ()> = Located<StmtKind<U>, U>;

#[derive(Debug, PartialEq)]
pub enum ExprKind<U = ()> {
    Mock { m: U }, // Remove someday...
    Name { id: Ident },
    Constant { value: Constant },
}
pub type Expr<U = ()> = Located<ExprKind<U>, U>;

pub type Unit<U = ()> = Vec<Stmt<U>>;

// Notes
// Use https://github.com/brendanzab/codespan
