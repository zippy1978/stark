use super::{clone_args, clone_expr, clone_ident, Args, Expr, Ident, Stmt, StmtKind, Stmts};

/// Folder. Allows generating a new AST by traversing an AST.
pub trait Folder<A: Clone = (), C = ()> {
    fn fold_stmts(&mut self, stmts: &Stmts, context: &mut C) -> Stmts<A> {
        let mut result = Stmts::new();
        for stmt in stmts {
            result.push(self.fold_stmt(stmt, context))
        }
        result
    }

    fn fold_stmt(&mut self, stmt: &Stmt, context: &mut C) -> Stmt<A> {
        Stmt {
            location: stmt.location,
            node: match &stmt.node {
                StmtKind::Expr { value } => self.fold_expr(&value, context),
                StmtKind::VarDecl { name, var_type } => self.fold_var_decl(name, var_type, context),
                StmtKind::Assign { target, value } => self.fold_assign(target, value, context),
                StmtKind::FuncDef {
                    name,
                    args,
                    body,
                    returns,
                } => self.fold_func_def(name, args, body, returns, context),
            },
            context: None,
        }
    }

    fn fold_expr(&mut self, expr: &Expr, context: &mut C) -> StmtKind<A> {
        StmtKind::Expr {
            value: Box::new(clone_expr(expr)),
        }
    }

    fn fold_var_decl(
        &mut self,
        name: &Ident,
        var_type: &Ident,
        context: &mut C,
    ) -> StmtKind<A> {
        StmtKind::VarDecl {
            name: clone_ident(name),
            var_type: clone_ident(var_type),
        }
    }

    fn fold_assign(&mut self, target: &Expr, value: &Expr, context: &mut C) -> StmtKind<A> {
        StmtKind::Assign {
            target: Box::new(clone_expr(target)),
            value: Box::new(clone_expr(value)),
        }
    }

    fn fold_func_def(
        &mut self,
        name: &Ident,
        args: &Args,
        body: &Stmts,
        returns: &Option<Ident>,
        context: &mut C,
    ) -> StmtKind<A> {
        StmtKind::FuncDef {
            name: clone_ident(name),
            args: Box::new(clone_args(args)),
            body: self.fold_stmts(body, context),
            returns: match returns {
                Some(ident) => Some(clone_ident(ident)),
                None => None,
            },
        }
    }
}
