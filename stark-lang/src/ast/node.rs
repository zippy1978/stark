use super::clone_args;
use super::clone_expr;
use super::clone_ident;
use super::clone_params;
use super::clone_stmts;
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
        Self {
            type_name: self.type_name.clone(),
        }
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
        Self {
            location,
            node,
            info: NodeInfo::new(),
        }
    }

    pub fn with_type_name(mut self, type_name: String) -> Self {
        self.info.type_name = Some(type_name);
        self
    }

    pub fn with_node(mut self, node: T) -> Self {
        self.node = node;
        self
    }
}

#[derive(Debug, PartialEq)]
pub struct Arg {
    pub name: Ident,
    pub var_type: Ident,
}

pub type Args = Vec<Arg>;

pub type Params = Vec<Expr>;

#[derive(Debug, PartialEq)]
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
    FuncDecl {
        name: Ident,
        args: Box<Args>,
        returns: Option<Ident>,
    },
    Import {
        name: Ident,
    },
    Module {
        name: Ident,
        stmts: Stmts,
    },
}

impl Clone for StmtKind {
    fn clone(&self) -> Self {
        match self {
            Self::Expr { value } => Self::Expr {
                value: Box::new(clone_expr(value)),
            },
            Self::VarDecl { name, var_type } => Self::VarDecl {
                name: clone_ident(name),
                var_type: clone_ident(var_type),
            },
            Self::Assign { target, value } => Self::Assign {
                target: clone_ident(target),
                value: Box::new(clone_expr(value)),
            },
            Self::FuncDef {
                name,
                args,
                body,
                returns,
            } => Self::FuncDef {
                name: clone_ident(name),
                args: Box::new(clone_args(args)),
                body: clone_stmts(body),
                returns: match returns {
                    Some(r) => Some(clone_ident(r)),
                    None => None,
                },
            },
            Self::FuncDecl {
                name,
                args,
                returns,
            } => Self::FuncDecl {
                name: clone_ident(name),
                args: Box::new(clone_args(args)),
                returns: match returns {
                    Some(r) => Some(clone_ident(r)),
                    None => None,
                },
            },
            Self::Import { name } => Self::Import {
                name: clone_ident(name),
            },
            Self::Module { name, stmts } => Self::Module {
                name: clone_ident(name),
                stmts: clone_stmts(stmts),
            },
        }
    }
}

pub type Stmt = Located<StmtKind>;

#[derive(Debug, PartialEq)]
pub enum ExprKind {
    Name { id: Ident },
    Constant { value: Constant },
    Call { id: Ident, params: Box<Params> },
}

impl Clone for ExprKind {
    fn clone(&self) -> Self {
        match self {
            ExprKind::Name { id } => ExprKind::Name {
                id: clone_ident(id),
            },
            ExprKind::Constant { value } => ExprKind::Constant {
                value: value.clone(),
            },
            ExprKind::Call { id, params } => ExprKind::Call {
                id: clone_ident(id),
                params: Box::new(clone_params(params)),
            },
        }
    }
}

pub type Expr = Located<ExprKind>;

pub type Ident = Located<String>;

pub type Stmts = Vec<Stmt>;
