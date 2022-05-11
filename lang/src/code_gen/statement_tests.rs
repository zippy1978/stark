use crate::ast::StmtKind;
#[cfg(test)]
use crate::{
    ast::{self, Location, Span},
    code_gen::{self, Context, Generable, Generator},
};

fn unit_with_statement(node: StmtKind) -> ast::Unit {
    let location = Location::new(0, 0, Span::new(0, 0));
    let stmt = ast::Stmt {
        location,
        custom: (),
        node,
    };
    let mut unit = ast::Unit::new();
    unit.push(stmt);
    unit
}

#[test]
fn gen_declaration() {
    let context = code_gen::Context::create();

    let mut generator = Generator::new(&context, code_gen::Config::new("test"));

    let node = ast::StmtKind::Declaration {
        variable: String::from("var"),
        var_type: String::from("type"),
    };
    let mut unit = unit_with_statement(node);

    match generator.generate(&unit) {
        Ok(generated) => assert_eq!(generated.logs.len(), 0),
        Err(_) => panic!(),
    }
}
