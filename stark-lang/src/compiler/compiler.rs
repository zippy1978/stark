//! Compiler.
use std::path::PathBuf;

use inkwell::{context::Context, memory_buffer::MemoryBuffer};

use crate::{
    ast::{self, Log, ModuleMap},
    code_gen::{link_bitcode_modules, CodeGenContext, CodeGenerator},
    parser::Parser,
    typing::{TypeChecker, TypeCheckerContext, TypeRegistry},
};

use super::{CompileError};

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

    /// Compiles input string.
    pub fn compile(&self, filename: &str, input: &str) -> CompileResult {
        let parser = Parser::new();
        let module_map = ModuleMap::empty();

        match parser.parse(filename, input) {
            Ok(ast) => self.compile_ast(filename, &ast, &module_map),
            Err(err) => Result::Err(CompileError::from(err)),
        }
    }

    /// Compiles files.
    pub fn compile_files(&self, paths: &[PathBuf]) -> CompileResult {
        match ModuleMap::from_paths(paths) {
            Ok(module_map) => self.compile_module_map(module_map),
            Err(err) => Result::Err(CompileError::from(err)),
        }
    }

    pub fn compile_module_map(&self, module_map: ModuleMap) -> CompileResult {
        let mut compiled_modules = Vec::<MemoryBuffer>::new();
        let mut logs = Vec::<Log>::new();
        for (name, ast) in module_map.modules() {
            match self.compile_ast(name, ast, &module_map) {
                Ok(mut output) => {
                    logs.append(&mut output.logs);
                    compiled_modules.push(output.bitcode);
                }
                Err(err) => return Result::Err(err),
            }
        }
        let llvm_context = Context::create();
        match link_bitcode_modules("main", compiled_modules, &llvm_context) {
            Ok(bitcode) => Result::Ok(CompileOutput { bitcode, logs }),
            Err(err) => Result::Err(CompileError::from(err)),
        }
    }

    /// Compiles AST
    pub fn compile_ast(&self, name: &str, ast: &ast::Stmts, module_map: &ModuleMap) -> CompileResult {
        // Type checking
        let mut type_checker = TypeChecker::new();
        let mut type_registry = TypeRegistry::new();
        let mut type_checker_context = TypeCheckerContext::new(&mut type_registry, module_map);
        match type_checker.check(ast, &mut type_checker_context) {
            Ok(typed_ast) => {
                // Code generation
                let llvm_context = Context::create();
                let mut code_gen_context = CodeGenContext::new(&type_registry, &llvm_context, module_map, name);
                let mut code_gen = CodeGenerator::new();
                match code_gen.generate(&typed_ast, &mut code_gen_context) {
                    Ok(output) => Result::Ok(CompileOutput {
                        bitcode: output.bitcode,
                        logs: output.logs,
                    }),
                    Err(err) => Result::Err(CompileError { logs: err.logs }),
                }
            }
            Err(err) => Result::Err(CompileError { logs: err.logs }),
        }
    }
}
