use super::{typing::TypeRegistry, Context};

#[test]
fn lookup_type() {
    let context = Context::create();

    let mut type_registry = TypeRegistry::new();

    type_registry.insert("int", super::typing::TypeKind::Primary, context.i16_type(), None);

    let ty = type_registry.lookup_type("int");

    match ty {
        Some(t) => assert_eq!(t.name, "int"),
        None => panic!(),
    }
}
