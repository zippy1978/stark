use cmake::Config;

extern crate lalrpop;

fn main() {
    lalrpop::process_root().unwrap();
    
    let dst = Config::new("../stark-runtime").build();
    println!("cargo:rustc-link-search=native={}", dst.display());
    println!("cargo:rustc-link-lib=dylib=stark");
}
