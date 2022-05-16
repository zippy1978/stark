use super::TypeRegistry;

#[test]
fn lookup_type() {
    let mut type_registry = TypeRegistry::new();

    type_registry.insert("int", super::typing::TypeKind::Primary, None);

    let ty = type_registry.lookup_type("int");

    match ty {
        Some(t) => assert_eq!(t.name, "int"),
        None => panic!(),
    }
}
