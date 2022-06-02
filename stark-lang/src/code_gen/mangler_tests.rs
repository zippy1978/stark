use super::Mangler;

#[test]
fn mangle_function() {

    let mangler = Mangler::default();
    assert_eq!(mangler.mangle_function_name(None, "myFunc"), "__stark_f__myFunc")
}

#[test]
fn mangle_function_with_module() {

    let mangler = Mangler::default();
    assert_eq!(mangler.mangle_function_name(Some("myModule".to_string()), "myFunc"), "__stark_f_myModule_myFunc")
}

#[test]
fn mangle_function_main() {

    let mangler = Mangler::default();
    assert_eq!(mangler.mangle_function_name(None, "main"), "main")
}