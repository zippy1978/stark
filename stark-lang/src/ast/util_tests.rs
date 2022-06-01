use crate::ast::StmtKind;

use super::{util, Args, Ident, Location, NodeInfo, Span, Stmt, Stmts};

#[test]
fn merge_asts() {
    let location = Location::new(0, 0, Span::new(0, 0), "-");

    let mut ast1 = Stmts::new();
    ast1.push(Stmt::new(
        location.clone(),
        StmtKind::FuncDef {
            name: Ident {
                location: location.clone(),
                node: "testFn1".to_string(),
                info: NodeInfo::new(),
            },
            args: Box::new(Args::new()),
            body: Stmts::new(),
            returns: None,
        },
    ));

    let mut ast2 = Stmts::new();
    ast2.push(Stmt::new(
        location.clone(),
        StmtKind::FuncDef {
            name: Ident {
                location: location.clone(),
                node: "testFn2".to_string(),
                info: NodeInfo::new(),
            },
            args: Box::new(Args::new()),
            body: Stmts::new(),
            returns: None,
        },
    ));

    let mut asts = Vec::new();
    asts.push(ast1);
    asts.push(ast2);

    let merged_ast = util::merge_asts(&asts[..]);

    assert_eq!(merged_ast.len(), 2);
    assert_eq!(
        match &merged_ast.get(0).unwrap().node {
            StmtKind::FuncDef {
                name,
                args: _,
                body: _,
                returns: _,
            } => &name.node,
            _ => panic!(),
        },
        "testFn1"
    );
    assert_eq!(
        match &merged_ast.get(1).unwrap().node {
            StmtKind::FuncDef {
                name,
                args: _,
                body: _,
                returns: _,
            } => &name.node,
            _ => panic!(),
        },
        "testFn2"
    );
}
