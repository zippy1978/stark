//! AST manipulation utilities.
use super::{Args, Ident, Expr, Arg};

pub fn clone_ident<A: Clone>(ident: &Ident) -> Ident<A> {
    
    Ident {
        location: ident.location,
        node: ident.node.clone(),
        context: None,
    }
}

pub fn clone_ident_with_context<A: Clone>(ident: &Ident, context: A) -> Ident<A> {
    
    Ident {
        location: ident.location,
        node: ident.node.clone(),
        context: Some(context),
    }
}

pub fn clone_expr<A: Clone>(expr: &Expr) -> Expr<A> {
    Expr {
        location: expr.location,
        node: expr.node.clone(),
        context: None,
    }
}

pub fn clone_expr_with_context<A: Clone>(expr: &Expr, context: A) -> Expr<A> {
    Expr {
        location: expr.location,
        node: expr.node.clone(),
        context: Some(context),
    }
}

pub fn clone_arg<A: Clone>(arg: &Arg) -> Arg<A> {
    Arg {
        name: clone_ident(&arg.name),
        var_type: clone_ident(&arg.var_type),
    }
}

pub fn clone_args<A: Clone>(args: &Args) -> Args<A> {
    let mut new_args = Args::new();
    for arg in args {
        new_args.push(clone_arg(arg));
    }
    new_args
}
