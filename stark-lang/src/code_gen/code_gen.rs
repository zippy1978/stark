use inkwell::{
    builder::Builder,
    context::Context,
    memory_buffer::MemoryBuffer,
    module::Module,
    types::{BasicMetadataTypeEnum, BasicType},
    values::{AnyValue, AnyValueEnum, BasicValue, BasicValueEnum},
};
use num_traits::ToPrimitive;

use crate::{
    ast::{self, Log, Logger, Visitor},
    typing::{SymbolScope, SymbolScopeType, SymbolTable, Type, TypeKind, TypeRegistry},
};

use super::{resolve_llvm_type, CodeGenError};

pub struct CodeGenContext<'ctx> {
    pub(crate) llvm_context: &'ctx Context,
    pub(crate) type_registry: &'ctx TypeRegistry,
    pub(crate) symbol_table: SymbolTable<AnyValueEnum<'ctx>>,
    pub(crate) builder: Builder<'ctx>,
    pub(crate) module: Module<'ctx>,
}

impl<'ctx> CodeGenContext<'ctx> {
    pub fn new(type_registry: &'ctx TypeRegistry, llvm_context: &'ctx Context) -> Self {
        CodeGenContext {
            type_registry,
            symbol_table: SymbolTable::<AnyValueEnum>::new(),
            llvm_context,
            builder: llvm_context.create_builder(),
            module: llvm_context.create_module("calculator"),
        }
    }
}

pub struct CodeGenOutput {
    pub bitcode: Option<MemoryBuffer>,
    pub logs: Vec<Log>,
}

pub type CodeGenResult = Result<CodeGenOutput, CodeGenError>;

/// Code generator.
/// Visits the AST to generate bitcode.
pub struct CodeGenerator {
    logger: Logger,
}

type VisitorResult<'ctx> = Result<Option<BasicValueEnum<'ctx>>, ()>;

impl<'ctx> Visitor<VisitorResult<'ctx>, CodeGenContext<'ctx>> for CodeGenerator {
    fn visit_stmts(
        &mut self,
        stmts: &ast::Stmts,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        let mut last_value = None;
        for stmt in stmts {
            match self.visit_stmt(stmt, context) {
                Ok(value) => last_value = value,
                Err(_) => (),
            }
        }

        Result::Ok(last_value)
    }

    fn visit_constant_expr(
        &mut self,
        constant: &ast::Constant,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        match constant {
            ast::Constant::Bool(_) => todo!(),
            ast::Constant::Str(_) => todo!(),
            ast::Constant::Int(value) => Result::Ok(Some(
                context
                    .llvm_context
                    .i64_type()
                    .const_int(value.to_u64().unwrap(), false)
                    .as_basic_value_enum(),
            )),
            ast::Constant::Float(_) => todo!(),
        }
    }

    fn visit_name_expr(
        &mut self,
        name: &ast::Ident,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        todo!();
    }

    fn visit_func_def(
        &mut self,
        name: &ast::Ident,
        args: &ast::Args,
        body: &ast::Stmts,
        returns: &Option<ast::Ident>,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        // Arguments
        let llvm_args = args
            .iter()
            .map(|a| resolve_llvm_type(&a.var_type.node, context).unwrap().into())
            .collect::<Vec<BasicMetadataTypeEnum>>();

        // Function type
        let fn_type = match returns {
            Some(returns) => resolve_llvm_type(&returns.node, context)
                .unwrap()
                .fn_type(&llvm_args[..], false),
            None => context
                .llvm_context
                .void_type()
                .fn_type(&llvm_args[..], false),
        };

        let function = context.module.add_function(&name.node, fn_type, None);

        // Add function to symbol table
        context
            .symbol_table
            .insert(
                &name.node,
                Type {
                    name: name.node.to_string(),
                    kind: TypeKind::Function {
                        args: args
                            .iter()
                            .map(|arg| arg.var_type.node.to_string())
                            .collect::<Vec<_>>(),
                        returns: match returns {
                            Some(return_type) => Some(return_type.node.to_string()),
                            None => None,
                        },
                    },
                    definition_location: Some(name.location),
                },
                name.location,
                function.as_any_value_enum(),
            )
            .unwrap();

        // Push scope
        context
            .symbol_table
            .push_scope(SymbolScope::new(SymbolScopeType::Function(
                name.node.to_string(),
            )));

        // Generate body
        let basic_block = context.llvm_context.append_basic_block(function, "entry");

        context.builder.position_at_end(basic_block);

        // Insert arguments on symbol table
        // TODO
        /*let x = function.get_nth_param(0).unwrap().into_int_value();
        let y = function.get_nth_param(1).unwrap().into_int_value();
        let z = function.get_nth_param(2).unwrap().into_int_value();

        let sum = context.builder.build_int_add(x, y, "sum");
        let sum = context.builder.build_int_add(sum, z, "sum");*/

        // Visit body
        match self.visit_stmts(body, context) {
            Ok(result) => match result {
                Some(value) => context.builder.build_return(Some(&value)),
                None => context.builder.build_return(None),
            },
            Err(err) => {
                return Result::Err(err);
            }
        };

        // Pop scope
        context.symbol_table.pop_scope();

        Result::Ok(None)
    }

    fn visit_var_decl(
        &mut self,
        name: &ast::Ident,
        var_type: &ast::Ident,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        todo!()
    }

    fn visit_assign(
        &mut self,
        target: &ast::Expr,
        value: &ast::Expr,
        context: &mut CodeGenContext<'ctx>,
    ) -> VisitorResult<'ctx> {
        todo!()
    }
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
                bitcode: Some(context.module.write_bitcode_to_memory()),
                logs: self.logger.logs(),
            }),
            Err(err) => Result::Err(CodeGenError {
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
