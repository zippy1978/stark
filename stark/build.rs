use cmake::Config;

fn main() {
    let dst = Config::new("../stark-runtime")
                 .define("CMAKE_BUILD_TYPE", "Release")
                 .build();

    println!("cargo:rustc-link-search=native={}", dst.display());

    // For the moment: runtime is dynamically linked to prevent symbol stripping
    println!("cargo:rustc-link-lib=dylib=stark");
    // At sometime it whould be interesting to switch to static linking
    // Using the --whole-archive linker flag (seems to be not supported yet)
    //println!("cargo:rustc-link-lib=static=stark");
}
