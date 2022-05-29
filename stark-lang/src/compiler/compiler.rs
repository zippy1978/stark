use inkwell::{context::Context, memory_buffer::MemoryBuffer};

use crate::{
    ast::{self, Log, LogLevel},
    code_gen::{CodeGenerator, CodeGenContext},
    parser::Parser,
    typing::{TypeChecker, TypeCheckerContext, TypeRegistry},
};

use super::CompileError;

pub struct Config {}

pub struct CompileOutput {
    pub bitcode: MemoryBuffer,
    pub logs: Vec<Log>,
}

impl CompileOutput {
    pub fn new(bitcode: MemoryBuffer) -> Self {
        CompileOutput {
            logs: Vec::new(),
            bitcode,
        }
    }
}

type CompileResult = Result<CompileOutput, CompileError>;

pub struct Compiler {}

impl Compiler {
    pub fn new() -> Self {
        Compiler {}
    }
    pub fn compile_string(&self, input: &str) -> CompileResult {
        let parser = Parser::new();

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

    pub fn compile_ast(&self, ast: &ast::Stmts) -> CompileResult {
        // Type checking
        let mut type_checker = TypeChecker::new();
        let mut type_registry = TypeRegistry::new();
        let mut type_checker_context = TypeCheckerContext::new(&mut type_registry);
        match type_checker.check(ast, &mut type_checker_context) {
            Ok(typed_ast) => {
                // Code generation
                let llvm_context = Context::create();
                let mut code_gen_context = CodeGenContext::new(&type_registry, &llvm_context);
                let mut code_gen = CodeGenerator::new();
                match code_gen.generate(&typed_ast, &mut code_gen_context) {
                    Ok(output) =>  {
                        Result::Ok(CompileOutput {bitcode: output.bitcode, logs: output.logs})
                    },
                    Err(err) => Result::Err(CompileError { logs: err.logs }),
                }
            }
            Err(err) => Result::Err(CompileError { logs: err.logs }),
        }
    }
}
