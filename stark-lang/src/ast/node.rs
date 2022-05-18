use super::Constant;
use super::Location;

#[derive(Debug, PartialEq)]
pub struct Located<T, C = ()> {
    pub location: Location,
    pub node: T,
    pub context: Option<C>,
}

impl<T> Located<T> {
    pub fn new(location: Location, node: T) -> Self {
        Self { location, node, context: None }
    }
}

#[derive(Debug, PartialEq)]
pub struct Arg<C = ()> {
    pub name: Ident<C>,
    pub var_type: Ident<C>,
}

pub type Args<C = ()> = Vec<Arg<C>>;

#[derive(Debug, PartialEq)]
pub enum StmtKind<C = ()> {
    Expr {
        value: Box<Expr<C>>,
    },
    VarDecl {
        name: Ident<C>,
        var_type: Ident<C>,
    },
    Assign {
        target: Box<Expr<C>>,
        value: Box<Expr<C>>,
    },
    FuncDef {
        name: Ident<C>,
        args: Box<Args<C>>,
        body: Stmts<C>,
        returns: Option<Ident<C>>,
    },
}
pub type Stmt<C =()> = Located<StmtKind<C>, C>;

#[derive(Debug, PartialEq)]
pub enum ExprKind<C = ()> {
    Name { id: Ident<C> },
    Constant { value: Constant },
}

impl Clone for ExprKind {
    fn clone(&self) -> Self {
        match self {
            ExprKind::Name { id } => ExprKind::Name {
                id: Ident {
                    location: id.location,
                    node: id.node.clone(),
                    context: id.context.clone(),
                },
            },
            ExprKind::Constant { value } => ExprKind::Constant {
                value: value.clone(),
            },
        }
    }
}

pub type Expr<C =()> = Located<ExprKind, C>;

pub type Ident<C =()> = Located<String, C>;

pub type Stmts<C =()> = Vec<Stmt<C>>;
