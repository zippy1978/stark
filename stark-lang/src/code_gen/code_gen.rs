use inkwell::{
    builder::Builder,
    context::Context,
    memory_buffer::MemoryBuffer,
    module::Module,
    values::{BasicValueEnum, PointerValue},
};

use crate::{
    ast::{self, Log, Logger, Visitor},
    typing::{SymbolScope, SymbolScopeType, SymbolTable, TypeRegistry},
};

use super::CodeGenError;

pub struct CodeGenContext<'ctx> {
    pub(crate) llvm_context: &'ctx Context,
    pub(crate) type_registry: &'ctx TypeRegistry,
    pub(crate) symbol_table: SymbolTable<PointerValue<'ctx>>,
    pub(crate) builder: Builder<'ctx>,
    pub(crate) module: Module<'ctx>,
}

impl<'ctx> CodeGenContext<'ctx> {
    pub fn new(type_registry: &'ctx TypeRegistry, llvm_context: &'ctx Context) -> Self {
        CodeGenContext {
            type_registry,
            symbol_table: SymbolTable::<PointerValue>::new(),
            llvm_context,
            builder: llvm_context.create_builder(),
            module: llvm_context.create_module("calculator"),
        }
    }
}

pub struct CodeGenOutput {
    pub bitcode: MemoryBuffer,
    pub logs: Vec<Log>,
}

pub type CodeGenResult = Result<CodeGenOutput, CodeGenError>;

pub(crate) type VisitorResult<'ctx> = Result<Option<BasicValueEnum<'ctx>>, ()>;

/// Code generator.
/// Visits the AST to generate bitcode.
pub struct CodeGenerator {
    pub(crate) logger: Logger,
}

impl<'ctx> CodeGenerator {
    pub fn new() -> Self {
        CodeGenerator {
            logger: Logger::new(),
        }
    }

    pub fn generate(
        &mut self,
        ast: &ast::Stmts,
        context: &mut CodeGenContext<'ctx>,
    ) -> CodeGenResult {
        self.logger.clear();

        // Push initial scope
        context
            .symbol_table
            .push_scope(SymbolScope::new(SymbolScopeType::Global));

        // Visit
        match self.visit_stmts(ast, context) {
            Ok(_) => Result::Ok(CodeGenOutput {
                bitcode:context.module.write_bitcode_to_memory(),
                logs: self.logger.logs(),
            }),
            Err(_) => Result::Err(CodeGenError {
                logs: self.logger.logs(),
            }),
        }

        //------------------- Just for testing : LLVM code gen !
        /*let module = &context.module;
        let builder = &context.builder;
        let i32_type = context.llvm_context.i32_type();
        let fn_type = i32_type.fn_type(&[i32_type.into(), i32_type.into(), i32_type.into()], false);
        let function = module.add_function("sum", fn_type, None);
        let basic_block = context.llvm_context.append_basic_block(function, "entry");

        builder.position_at_end(basic_block);

        let x = function.get_nth_param(0).unwrap().into_int_value();
        let y = function.get_nth_param(1).unwrap().into_int_value();
        let z = function.get_nth_param(2).unwrap().into_int_value();

        let sum = builder.build_int_add(x, y, "sum");
        let sum = builder.build_int_add(sum, z, "sum");

        builder.build_return(Some(&sum));*/

        //------------------------------
    }
}

impl<'ctx> Visitor<VisitorResult<'ctx>, CodeGenContext<'ctx>> for CodeGenerator {
    fn visit_stmts(
        &mut self,
        stmts: &ast::Stmts,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        self.handle_visit_stmts(stmts, context)
    }

    fn visit_constant_expr(
        &mut self,
        constant: &ast::Constant,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        self.handle_visit_constant_expr(constant, context)
    }

    fn visit_name_expr(
        &mut self,
        name: &ast::Ident,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        self.handle_visit_name_expr(name, context)
    }

    fn visit_func_def(
        &mut self,
        name: &ast::Ident,
        args: &ast::Args,
        body: &ast::Stmts,
        returns: &Option<ast::Ident>,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        self.handle_visit_func_def(name, args, body, returns, context)
    }

    fn visit_var_decl(
        &mut self,
        name: &ast::Ident,
        var_type: &ast::Ident,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        self.handle_visit_var_decl(name, var_type, context)
    }

    fn visit_assign(
        &mut self,
        target: &ast::Ident,
        value: &ast::Expr,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        self.handle_visit_assign(target, value, context)
    }
}
