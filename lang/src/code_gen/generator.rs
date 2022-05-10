use crate::ast::{self, Visitor, Location, Span};
use inkwell::context::Context as LLVMContext;
use inkwell::{builder::Builder, module::Module};

use super::log::Log;
use super::{Bitcode, CodeGenError, LogLevel, Logger};

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

pub struct GeneratorResult<'a> {
    bitcode: Bitcode,
    logs: Vec<Log<'a>>,
}

pub struct Generator<'ctx> {
    context: &'ctx Context,
    builder: Builder<'ctx>,
    module: Module<'ctx>,
    config: Config<'ctx>,
    // TODO : use ref and declare above ???
    logger: Logger<'ctx>,
}

impl<'ctx> Generator<'ctx> {
    pub fn new(context: &'ctx Context, config: Config<'ctx>) -> Generator<'ctx> {
        Generator {
            context,
            builder: context.create_builder(),
            module: context.create_module(config.name),
            config,
            logger: Logger::new(),
        }
    }

    pub fn generate(&mut self, unit: &ast::Unit) -> Result<(GeneratorResult), CodeGenError> {
        self.visit_unit(unit);

        /*Result::Ok(GeneratorResult {
            bitcode: Bitcode {},
            logs: self.logs.to_vec(),
        })*/
        Result::Err(CodeGenError { logs: self.logger.logs() })
    }

}

impl<'ctx> Visitor for Generator<'ctx> {
    fn visit_unit(&mut self, unit: &ast::Unit) {
        let unit_iter = unit.iter();
        for s in unit_iter {
            self.visit_stmt(s);
        }
    }

    fn visit_stmt(&mut self, stmt: &ast::Stmt) {

        self.logger.add(Log {
            location: stmt.location,
            level: LogLevel::Warning,
            message: "Not implemented yet !",
        });

        let i64_type = self.context.i64_type();
        let fn_type = i64_type.fn_type(&[i64_type.into(), i64_type.into(), i64_type.into()], false);
        let function = self.module.add_function("sum", fn_type, None);
        let basic_block = self.context.append_basic_block(function, "entry");

        self.builder.position_at_end(basic_block);

        let x = function.get_nth_param(0).unwrap().into_int_value();
        let y = function.get_nth_param(1).unwrap().into_int_value();
        let z = function.get_nth_param(2).unwrap().into_int_value();

        let sum = self.builder.build_int_add(x, y, "sum");
        let sum = self.builder.build_int_add(sum, z, "sum");

        self.builder.build_return(Some(&sum));

        match &stmt.node {
            ast::StmtKind::Expr { value } => self.visit_expr(&value),
            ast::StmtKind::Declaration { variable, var_type } => {
                println!("declaration {} : {}", variable, var_type)
            }
            ast::StmtKind::Assign => todo!(),
        }
    }

    fn visit_expr(&mut self, expr: &ast::Expr) {

        self.logger.add(Log {
            location: expr.location,
            level: LogLevel::Warning,
            message: "Not implemented yet !",
        });

        match &expr.node {
            ast::ExprKind::Mock { m } => todo!(),
            ast::ExprKind::Name { id } => println!("{:?}", id),
            ast::ExprKind::Constant { value } => println!("{:?}", value),
        }
    }
}
