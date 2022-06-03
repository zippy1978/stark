//! AST manipulation utilities.
use super::{Arg, Args, Expr, Ident, Location, NodeInfo, Params, Stmt, StmtKind, Stmts};

pub fn clone_ident(ident: &Ident) -> Ident {
    Ident {
        location: ident.location.clone(),
        node: ident.node.clone(),
        info: ident.info.clone(),
    }
}

pub fn clone_expr(expr: &Expr) -> Expr {
    Expr {
        location: expr.location.clone(),
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

pub fn clone_stmt(stmt: &Stmt) -> Stmt {
    Stmt {
        location: stmt.location.clone(),
        node: stmt.node.clone(),
        info: stmt.info.clone(),
    }
}

pub fn clone_stmts(stmts: &Stmts) -> Stmts {
    let mut new_stmts = Stmts::new();
    for stmt in stmts {
        new_stmts.push(clone_stmt(stmt));
    }
    new_stmts
}

/// Merge ASTs into a sungle AST.
/// The merge is performed by cloning input ASTs.
pub fn merge_asts(asts: &[Stmts]) -> Stmts {
    let mut new_ast = Stmts::new();

    for ast in asts {
        for stmt in ast {
            new_ast.push(clone_stmt(stmt));
        }
    }

    new_ast
}

/// Wrap an AST into a module.
pub fn wrap_ast_in_module(ast: &Stmts, module_name: &str) -> Stmts {
    let module = StmtKind::Module {
        name: Ident {
            location: Location::start(module_name),
            node: module_name.to_string(),
            info: NodeInfo::new(),
        },
        stmts: clone_stmts(ast),
    };
    let mut result = Stmts::new();
    result.push(Stmt {
        location: Location::start(module_name),
        node: module,
        info: NodeInfo::new(),
    });
    result
}
