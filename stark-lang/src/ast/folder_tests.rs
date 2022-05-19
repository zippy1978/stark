use crate::ast::NodeInfo;

use super::Folder;

#[cfg(test)]

struct CopyFolder {}
impl Folder for CopyFolder {}

#[test]
fn fold_ast() {
    use crate::ast::{Ident, Location, Span, Stmt, StmtKind};

    use super::Stmts;

    let dummy_location = Location::new(0, 0, Span::new(0, 0));
    let int_type_ident = Ident {
        location: dummy_location,
        node: "int".to_string(),
        info: NodeInfo::new()
    };
    let var_name_ident = Ident {
        location: dummy_location,
        node: "varName".to_string(),
        info: NodeInfo::new()
    };
    let var_decl_stmt = Stmt {
        location: dummy_location,
        node: StmtKind::VarDecl {
            name: var_name_ident,
            var_type: int_type_ident,
        },
        info: NodeInfo::new()
    };

    let mut ast = Stmts::new();
    ast.push(var_decl_stmt);

    let mut copy_folder = CopyFolder {};
    let folded_ast = copy_folder.fold_stmts(&ast, &mut ());

    assert_eq!(folded_ast.len(), 1);
    match &folded_ast.get(0).unwrap().node {
        StmtKind::VarDecl { name, var_type } => {
            assert_eq!(name.node, "varName");
            assert_eq!(var_type.node, "int");
        }
        _ => panic!(),
    }
}
