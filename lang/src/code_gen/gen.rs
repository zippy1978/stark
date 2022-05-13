use inkwell::context::Context;

use crate::ast::{self};

use super::{symbol::{SymbolTable}, typing::TypeRegistry, CodeGenBuilder, Logger, CodeGenError};

pub struct Config {}

pub struct CodeGen {}


impl CodeGen {
    pub fn from_ast(ast: &ast::Unit) -> Result<(),CodeGenError> {
        let context = Context::create();
        // TODO : use real name !!!
        let module = context.create_module("calculator");
        let builder = context.create_builder();
        let mut type_registry = TypeRegistry::new();
        let mut symbol_table = SymbolTable::new();
        let mut logger = Logger::new();

        // Register builtin types
        // int
        type_registry.insert(
            &String::from("int"),
            super::typing::TypeKind::Primary,
            context.i64_type(),
            None,
        );

        // Root block
        let i64_type = context.i64_type();
        let fn_type = i64_type.fn_type(&[i64_type.into(), i64_type.into(), i64_type.into()], false);
        let function = module.add_function("sum", fn_type, None);
        let basic_block = context.append_basic_block(function, "test");
        builder.position_at_end(basic_block);

        let mut code_gen_builder =
            CodeGenBuilder::new(&context, &builder, &mut type_registry, &mut symbol_table, &mut logger);

        match code_gen_builder.build(ast) {
            Ok(_) => Result::Ok(()),
            Err(err) => Result::Err(err),
        }
    }
}

