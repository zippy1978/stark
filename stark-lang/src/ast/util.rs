//! AST manipulation utilities.
use super::{Args, Ident, Expr, Arg, Params};

pub fn clone_ident(ident: &Ident) -> Ident {
    
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

pub fn clone_params(params: &Params) -> Params {
    let mut new_params = Params::new();
    for expr in params {
        new_params.push(clone_expr(expr));
    }
    new_params
}
