use super::{clone_args, clone_expr, clone_ident, Args, Expr, Ident, Stmt, StmtKind, Stmts};

/// Folder. Allows generating a new AST by traversing an AST.
pub trait Folder<C = ()> {
    fn fold_stmts(&mut self, stmts: &Stmts, context: &mut C) -> Stmts {
        let mut result = Stmts::new();
        for stmt in stmts {
            result.push(self.fold_stmt(stmt, context))
        }
        result
    }

    fn fold_stmt(&mut self, stmt: &Stmt, context: &mut C) -> Stmt {
        Stmt {
            location: stmt.location.clone(),
            node: match &stmt.node {
                StmtKind::Expr { value } => StmtKind::Expr {
                    value: Box::new(self.fold_expr(&value, context)),
                },
                StmtKind::VarDecl { name, var_type } => self.fold_var_decl(name, var_type, context),
                StmtKind::Assign { target, value } => self.fold_assign(target, value, context),
                StmtKind::FuncDef {
                    name,
                    args,
                    body,
                    returns,
                } => self.fold_func_def(name, args, body, returns, context),
                StmtKind::FuncDecl {
                    name,
                    args,
                    returns,
                } => self.fold_func_decl(name, args, returns, context),
                StmtKind::Import { name } => self.fold_import(name, context),
                StmtKind::Module { name, stmts } => self.fold_module(name, stmts, context),
            },
            info: stmt.info.clone(),
        }
    }

    fn fold_expr(&mut self, expr: &Expr, _context: &mut C) -> Expr {
        clone_expr(expr)
    }

    fn fold_import(&mut self, name: &Ident, _context: &mut C) -> StmtKind {
        StmtKind::Import {
            name: clone_ident(name),
        }
    }

    fn fold_module(&mut self, name: &Ident, stmts: &Stmts, context: &mut C) -> StmtKind {
        StmtKind::Module {
            name: clone_ident(name),
            stmts: self.fold_stmts(stmts, context),
        }
    }

    fn fold_var_decl(&mut self, name: &Ident, var_type: &Ident, _context: &mut C) -> StmtKind {
        StmtKind::VarDecl {
            name: clone_ident(name),
            var_type: clone_ident(var_type),
        }
    }

    fn fold_assign(&mut self, target: &Ident, value: &Expr, context: &mut C) -> StmtKind {
        StmtKind::Assign {
            target: clone_ident(target),
            value: Box::new(self.fold_expr(value, context)),
        }
    }

    fn fold_func_def(
        &mut self,
        name: &Ident,
        args: &Args,
        body: &Stmts,
        returns: &Option<Ident>,
        context: &mut C,
    ) -> StmtKind {
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

    fn fold_func_decl(
        &mut self,
        name: &Ident,
        args: &Args,
        returns: &Option<Ident>,
        _context: &mut C,
    ) -> StmtKind {
        StmtKind::FuncDecl {
            name: clone_ident(name),
            args: Box::new(clone_args(args)),
            returns: match returns {
                Some(ident) => Some(clone_ident(ident)),
                None => None,
            },
        }
    }
}
