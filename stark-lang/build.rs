use cmake::Config;

extern crate lalrpop;

fn main() {
    lalrpop::process_root().unwrap();

    let dst = Config::new("../stark-runtime")
        .define("CMAKE_BUILD_TYPE", "Release")
        .build();

    println!("cargo:rustc-link-search=native={}", dst.display());

    // For the moment: runtime is dynamically linked to prevent symbol stripping
    println!("cargo:rustc-link-lib=dylib=stark");
    // At sometime it whould be interesting to switch to static linking
    //println!("cargo:rustc-link-arg=-fPIC");
    //println!("cargo:rustc-link-arg=-Wl,-all_load");
    //println!("cargo:rustc-link-arg={}/libstark.a", dst.display());

   
}
//-rdynamic
