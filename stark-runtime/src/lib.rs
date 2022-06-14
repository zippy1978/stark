//! Stark runtime.
//! Use the exported [build_and_link_runtime] function 
//! into build scripts to trigger build and link the stark runtime.

use std::env;

use cmake::Config;

/// Builds and link stark runtime.
pub fn build_and_link_runtime() {
    let dst = Config::new("../stark-runtime")
        .define("CMAKE_BUILD_TYPE", "Release")
        .build();

    println!("cargo:rustc-link-search=native={}", dst.display());

    let target_os = env::var("CARGO_CFG_TARGET_OS");

    // Common linker settings
    println!("cargo:rustc-link-arg=-rdynamic");
    println!("cargo:rustc-link-arg=-fPIC");

    // Host specific linker settings
    match target_os.as_ref().map(|x| &**x) {
        Ok("linux") => println!("cargo:rustc-link-arg=-Wl,--no-as-needed"),
        Ok("openbsd") | Ok("bitrig") | Ok("netbsd") | Ok("macos") | Ok("ios") => {}
        Ok("windows") => {}
        tos => panic!("unknown target os {:?}!", tos),
    }

    // Runtime dynamic linking
    println!("cargo:rustc-link-arg=-lstark");

    /*
    // macOS specific static linking
    println!("cargo:rustc-link-arg=-rdynamic");
    println!("cargo:rustc-link-arg=-fPIC");
    // Make sure to preserve all symbols from the runtime (even if not used at compile time)
    println!("cargo:rustc-link-arg=-Wl,-force_load");
    println!("cargo:rustc-link-arg={}/libstark.a", dst.display());
    */
}
