extern crate lalrpop;

fn main() {
    lalrpop::process_root().unwrap();
    stark_runtime::build_and_link_runtime();
}
