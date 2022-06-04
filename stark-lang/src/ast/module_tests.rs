use std::collections::HashMap;

use super::{Expr, ExprKind, Ident, Location, ModuleMap, NodeInfo, Stmt, Stmts};

#[test]
fn get_inner_ast() {
    // Build AST with module and 1 stmt inside that module
    let mut inner_ast = Stmts::new();
    inner_ast.push(Stmt {
        location: Location::start("module"),
        node: super::StmtKind::Expr {
            value: Box::new(Expr {
                location: Location::start("module"),
                node: ExprKind::Name {
                    id: Ident {
                        location: Location::start("module"),
                        node: "myVar".to_string(),
                        info: NodeInfo::new(),
                    },
                },
                info: NodeInfo::new(),
            }),
        },
        info: NodeInfo::new(),
    });
    let module_stmt = Stmt {
        location: Location::start("module"),
        node: super::StmtKind::Module {
            name: Ident {
                location: Location::start("module"),
                node: "module".to_string(),
                info: NodeInfo::new(),
            },
            stmts: inner_ast,
        },
        info: NodeInfo::new(),
    };
    let mut ast = Stmts::new();
    ast.push(module_stmt);

    // Create module map
    let mut modules = HashMap::new();
    modules.insert("module".to_string(), ast);
    let module_map = ModuleMap::new(modules);

    // Assert the inner AST contains 1 stmt
    assert_eq!(module_map.get_inner_ast("module").unwrap().len(), 1);
    // Assert the stmt found is the actual expr one
    match &module_map
        .get_inner_ast("module")
        .unwrap()
        .get(0)
        .unwrap()
        .node
    {
        crate::ast::StmtKind::Expr { value: _ } => assert!(true),
        _ => panic!("wrong statement found"),
    };
}
