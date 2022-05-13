use inkwell::builder::Builder;

use crate::ast::{self, Visitor};

use super::{
    symbol::{SymbolScope, SymbolScopeType, SymbolTable},
    typing::TypeRegistry,
    CodeGenError, Log, Logger,
};

pub struct CodeGenBuilderResult {
    //pub bitcode: Bitcode,
    pub logs: Vec<Log>,
}

pub struct CodeGenBuilder<'a> {
    builder: &'a Builder<'a>,
    type_registry: &'a mut TypeRegistry<'a>,
    symbol_table: &'a mut SymbolTable<'a>,
    logger: &'a Logger,
}

impl<'a> CodeGenBuilder<'a> {
    pub fn new(
        builder: &'a Builder,
        type_registry: &'a mut TypeRegistry<'a>,
        symbol_table: &'a mut SymbolTable<'a>,
        logger: &'a Logger,
    ) -> Self {
        CodeGenBuilder {
            builder,
            type_registry,
            symbol_table,
            logger,
        }
    }

    pub fn build(&mut self, unit: &ast::Unit) -> Result<CodeGenBuilderResult, CodeGenError> {
        match self.visit_unit(unit) {
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
    fn visit_unit(&mut self, unit: &ast::Unit) -> Result<(), ()> {
        // Push initial scope
        self.symbol_table
            .push_scope(SymbolScope::new(SymbolScopeType::Global));

        for s in unit {
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
            ast::StmtKind::Declaration { variable, var_type } => {
                // TO CONTINUE ! :)
                // Quick and dirty test
                let ty = self.type_registry.lookup_type(var_type).unwrap();
                self.builder.build_alloca(ty.llvm_type, &variable);
                Result::Ok(())
            }
            ast::StmtKind::Assign => todo!(),
        }
    }

    fn visit_expr(&mut self, expr: &ast::Expr) -> Result<(), ()> {
        todo!()
    }
}
