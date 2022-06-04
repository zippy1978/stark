import test
/**
 * This is my main :)
 */
func main() => int {
    test.assert()
    before()
    after()

}

/* TODO NEXT

1 - implement dotted ident in parser >> DONE
2 - add module_map to type check / code gen contexts
3 - implement type check import : get module declarations from module map and handle_fold_func_decl
4 - implement code gen import : get module declarations from module map, add handle_visit_func_decl


*/
