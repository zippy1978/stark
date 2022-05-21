use super::{TypeRegistry, PrimaryKind};

#[test]
fn lookup_type() {
    let mut type_registry = TypeRegistry::new();

    type_registry.insert("my_type", super::typing::TypeKind::Primary(PrimaryKind::Int("my_type".to_string())), None);

    let ty = type_registry.lookup_type("my_type");

    match ty {
        Some(t) => assert_eq!(t.name, "my_type"),
        None => panic!(),
    }
}
