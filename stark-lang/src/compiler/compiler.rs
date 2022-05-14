use inkwell::context::Context;

use crate::{
    ast::{self, Log, LogLevel, Logger},
    code_gen::CodeGenBuilder,
    parser::Parser,
    typing::{SymbolTable, TypeKind, TypeRegistry},
};

use super::CompileError;

pub struct Config {}

pub struct CompileOutput {
    pub logs: Vec<Log>,
}

impl CompileOutput {
    pub fn new() -> Self {
        CompileOutput { logs: Vec::new() }
    }
}

type CompileResult = Result<CompileOutput, CompileError>;

pub struct Compiler {}

impl Compiler {
    pub fn new() -> Self {
        Compiler {}
    }
    pub fn compile_string(&self, input: &str) -> CompileResult {
        let parser = Parser {};

        match parser.parse(input) {
            Ok(ast) => self.compile_ast(&ast),
            Err(err) => {
                let mut compile_error = CompileError::new();
                let log = Log::new("syntax error", LogLevel::Error)
                    .with_label(err.to_string(), err.location);
                compile_error.logs.push(log);
                Result::Err(compile_error)
            }
        }
    }

    pub fn compile_ast(&self, ast: &ast::Unit) -> CompileResult {
        let mut compile_output = CompileOutput::new();
        let log = Log::new("code gen is not implemented yet !", LogLevel::Warning);
        compile_output.logs.push(log);
        Result::Ok(compile_output)

        /*
        // TODO : rewrite it all !

        let context = Context::create();
        // TODO : use real name !!!
        let module = context.create_module("calculator");
        let builder = context.create_builder();
        let mut type_registry = TypeRegistry::new();
        let mut symbol_table = SymbolTable::new();
        let mut logger = Logger::new();

        // Register builtin types
        // int
        type_registry.insert(&String::from("int"), TypeKind::Primary, None);

        // Root block
        let i64_type = context.i64_type();
        let fn_type = i64_type.fn_type(&[i64_type.into(), i64_type.into(), i64_type.into()], false);
        let function = module.add_function("sum", fn_type, None);
        let basic_block = context.append_basic_block(function, "test");
        builder.position_at_end(basic_block);

        let mut code_gen_builder = CodeGenBuilder::new(
            &context,
            &builder,
            &mut type_registry,
            &mut symbol_table,
            &mut logger,
        );

        match code_gen_builder.build(ast) {
            Ok(_) => Result::Ok(CompileOutput {
                logs: logger.logs(),
            }),
            Err(err) => Result::Err(CompileError { logs: err.logs }),
        }*/
    }
}