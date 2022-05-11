use crate::ast::{self, Visitor};
use crate::code_gen::typing::Type;
use inkwell::context::Context as LLVMContext;
use inkwell::values::PointerValue;
use inkwell::{builder::Builder, module::Module};

use super::log::Log;
use super::symbol::{SymbolScope, SymbolScopeType, SymbolTable};
use super::{Bitcode, CodeGenError, LogLevel, Logger};

pub type GenerableResult<'a> = Result<PointerValue<'a>, CodeGenError<'a>>;

pub trait Generable<'a> {
    fn generate(&'a self, generator: &'a Generator) -> GenerableResult<'a>;
}

struct VisitorError {}

pub type Context = LLVMContext;

// TODO : implement a builder !
pub struct Config<'a> {
    name: &'a str,
}

impl<'a> Config<'a> {
    pub fn new(name: &'a str) -> Self {
        Config { name }
    }
}

pub struct GeneratorResult<'ctx> {
    //pub bitcode: Bitcode,
    pub logs: Vec<Log<'ctx>>,
}

pub struct Generator<'ctx> {
    context: &'ctx Context,
    module: Module<'ctx>,
    builder: Builder<'ctx>,
    symbol_table: SymbolTable<'ctx>,
    config: Config<'ctx>,
    logger: Logger<'ctx>,
}

impl<'ctx> Generator<'ctx> {
    pub fn new(context: &'ctx Context, config: Config<'ctx>) -> Generator<'ctx> {
        Generator {
            context,
            module: context.create_module(config.name),
            builder: context.create_builder(),
            symbol_table: SymbolTable::new(),
            config,
            logger: Logger::new(),
        }
    }

    pub(crate) fn context(&self) -> &Context {
        self.context
    }

    pub(crate) fn builder(&self) -> &Builder {
        &self.builder
    }

    pub fn generate(&mut self, unit: &ast::Unit) -> Result<GeneratorResult, CodeGenError> {
        // Root block
        let i64_type = self.context.i64_type();
        let fn_type = i64_type.fn_type(&[i64_type.into(), i64_type.into(), i64_type.into()], false);
        let function = self.module.add_function("sum", fn_type, None);
        let basic_block = self.context.append_basic_block(function, "test");
        self.builder.position_at_end(basic_block);

        match self.visit_unit(unit) {
            Ok(_) => Result::Ok(GeneratorResult {
                logs: self.logger.logs(),
            }),
            Err(_) => Result::Err(CodeGenError {
                logs: self.logger.logs(),
            }),
        }
    }
}

impl<'ctx> Visitor<Result<(), ()>> for Generator<'ctx> {
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
        // Test = works here !
        let i64_type = self.context.i64_type();
        let builder = &self.builder;
        builder.build_alloca(i64_type, "ddd");

        // TODO : handle result
        match stmt.generate(self) {
            Ok(_) => Result::Ok(()),
            Err(_) => Result::Err(()),
        }
    }

    fn visit_expr(&mut self, expr: &ast::Expr) -> Result<(), ()> {
        self.logger.add(Log {
            location: expr.location,
            level: LogLevel::Warning,
            message: "Not implemented yet !",
        });

        match &expr.node {
            ast::ExprKind::Mock { m } => todo!(),
            ast::ExprKind::Name { id } => Result::Err(()),
            ast::ExprKind::Constant { value } => Result::Err(()),
        }
    }
}
