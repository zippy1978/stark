//! AST manipulation utilities.
use super::{Args, Ident, Expr, Arg, NodeInfo};

pub fn clone_ident(ident: &Ident) -> Ident {
    
    Ident {
        location: ident.location,
        node: ident.node.clone(),
        info: ident.info.clone(),
    }
}

pub fn clone_ident_with_info(ident: &Ident, info: NodeInfo) -> Ident {
    
    Ident {
        location: ident.location,
        node: ident.node.clone(),
        info: ident.info.clone(),
    }
}

pub fn clone_expr(expr: &Expr) -> Expr {
    Expr {
        location: expr.location,
        node: expr.node.clone(),
        info: expr.info.clone(),
    }
}

pub fn clone_expr_with_info(expr: &Expr, info: NodeInfo) -> Expr {
    Expr {
        location: expr.location,
        node: expr.node.clone(),
        info: expr.info.clone(),
    }
}

pub fn clone_arg(arg: &Arg) -> Arg {
    Arg {
        name: clone_ident(&arg.name),
        var_type: clone_ident(&arg.var_type),
    }
}

pub fn clone_args(args: &Args) -> Args {
    let mut new_args = Args::new();
    for arg in args {
        new_args.push(clone_arg(arg));
    }
    new_args
}
