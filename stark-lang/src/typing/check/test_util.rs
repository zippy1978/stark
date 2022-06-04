use crate::{
    ast::{self, ModuleMap},
    parser::Parser,
    typing::{TypeChecker, TypeCheckerContext, TypeRegistry, TypeCheckerResult},
};

pub(crate) fn ast_from(input: &str) -> ast::Stmts {
    let parser = Parser::new();
    parser.parse("-", input).unwrap()
}

pub(crate) fn type_check(input: &str) -> TypeCheckerResult {
    let mut type_checker = TypeChecker::new();
    let mut type_registry = TypeRegistry::new();
    let module_map = ModuleMap::empty();
    let mut context = TypeCheckerContext::new(&mut type_registry, &module_map);

    type_checker.check(&ast_from(input), &mut context)
}

pub(crate) fn type_check_in_function(input: &str) -> TypeCheckerResult {
    type_check(format!("func test() {{{}}}", input).as_str())
}
