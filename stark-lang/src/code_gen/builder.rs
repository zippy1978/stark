use inkwell::{builder::Builder, context::Context};

use crate::{ast::{self, Visitor, Log, Logger}, typing::{TypeRegistry, SymbolTable, SymbolScopeType, SymbolScope}};

use super::CodeGenError;


pub struct CodeGenBuilderResult {
    //pub bitcode: Bitcode,
    pub logs: Vec<Log>,
}

pub struct CodeGenBuilder<'a> {
    context: &'a Context,
    builder: &'a Builder<'a>,
    type_registry: &'a mut TypeRegistry,
    symbol_table: &'a mut SymbolTable<'a>,
    logger: &'a Logger,
}

impl<'a> CodeGenBuilder<'a> {
    pub fn new(
        context: &'a Context,
        builder: &'a Builder,
        type_registry: &'a mut TypeRegistry,
        symbol_table: &'a mut SymbolTable<'a>,
        logger: &'a Logger,
    ) -> Self {
        CodeGenBuilder {
            context,
            builder,
            type_registry,
            symbol_table,
            logger,
        }
    }

    pub fn build(&mut self, stmts: &ast::Stmts) -> Result<CodeGenBuilderResult, CodeGenError> {
        match self.visit_stmts(stmts) {
            Ok(_) => Result::Ok(CodeGenBuilderResult {
                logs: self.logger.logs(),
            }),
            Err(_) => todo!(),
        }
    }
}

// TO CONTINUE
// https://createlang.rs/01_calculator/ast_traversal.html

impl<'a> Visitor<Result<(), ()>> for CodeGenBuilder<'a> {
    fn visit_stmts(&mut self, stmts: &ast::Stmts) -> Result<(), ()> {
        // Push initial scope
        self.symbol_table
            .push_scope(SymbolScope::new(SymbolScopeType::Global));

        for s in stmts {
            match self.visit_stmt(s) {
                Ok(_) => (),
                Err(_) => return Result::Err(()),
            }
        }

        Result::Ok(())
    }

    fn visit_stmt(&mut self, stmt: &ast::Stmt) -> Result<(), ()> {
        match &stmt.node {
            ast::StmtKind::Expr { value } => todo!(),
            ast::StmtKind::VarDef { name: variable, var_type } => {
                // TO CONTINUE ! :)
                // Quick and dirty test
                //self.context.i128_type();
                let ty = self.type_registry.lookup_type(var_type).unwrap();
                self.builder.build_alloca(self.context.i64_type(), &variable);
                Result::Ok(())
            }
            _ => todo!(),
        }
    }

    fn visit_expr(&mut self, expr: &ast::Expr) -> Result<(), ()> {
        todo!()
    }
}
