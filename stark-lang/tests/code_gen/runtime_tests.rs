extern "C" {
    fn __stark_r_mm_init();
}

#[test]
fn runtime_link() {
    unsafe { __stark_r_mm_init() }
}