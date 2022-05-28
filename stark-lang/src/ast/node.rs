use super::Constant;
use super::Location;

/// Holds informaton (such as type name) of an AST node.
#[derive(Debug, PartialEq)]
pub struct NodeInfo {
    pub type_name: Option<String>,
}

impl NodeInfo {
    pub fn new() -> Self {
        NodeInfo { type_name: None }
    }
}

impl Clone for NodeInfo {
    fn clone(&self) -> Self {
        Self { type_name: self.type_name.clone() }
    }
}

/// An AST node (which is located in source code).
#[derive(Debug, PartialEq)]
pub struct Located<T> {
    pub location: Location,
    pub node: T,
    pub info: NodeInfo,
}

impl<T> Located<T> {
    pub fn new(location: Location, node: T) -> Self {
        Self { location, node, info: NodeInfo::new() }
    }

    pub fn with_type_name(mut self, type_name: String) -> Self {
        self.info.type_name = Some(type_name);
        self
    }
}

#[derive(Debug, PartialEq)]
pub struct Arg {
    pub name: Ident,
    pub var_type: Ident,
}

pub type Args = Vec<Arg>;

#[derive(Debug, PartialEq,)]
pub enum StmtKind {
    Expr {
        value: Box<Expr>,
    },
    VarDecl {
        name: Ident,
        var_type: Ident,
    },
    Assign {
        target: Ident,
        value: Box<Expr>,
    },
    FuncDef {
        name: Ident,
        args: Box<Args>,
        body: Stmts,
        returns: Option<Ident>,
    },
}

pub type Stmt = Located<StmtKind>;

#[derive(Debug, PartialEq)]
pub enum ExprKind {
    Name { id: Ident },
    Constant { value: Constant },
}

impl Clone for ExprKind {
    fn clone(&self) -> Self {
        match self {
            ExprKind::Name { id } => ExprKind::Name {
                id: Ident {
                    location: id.location,
                    node: id.node.clone(),
                    info: id.info.clone(),
                },
            },
            ExprKind::Constant { value } => ExprKind::Constant {
                value: value.clone(),
            },
        }
    }
}

pub type Expr = Located<ExprKind>;

pub type Ident = Located<String>;

pub type Stmts = Vec<Stmt>;
