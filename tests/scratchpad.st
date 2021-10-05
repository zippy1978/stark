
z := (f: string) {
    t := (a: int, b: int) => int {
        return a + b
    }
    println(f)
    println("result is " + t(1,2) as string)
}
//println()
z("Gilles")