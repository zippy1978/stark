test : (a: int, b: int) => int
test = null

// This should be fixed
/*if (test == null) {
    println("null")
}*/

// TODO :
// add tests
// support for direct assignement and type inference

func toto(a: int, b: int): int {
    return a + b
}

//This should be fixed
/*func callme(c: (a: int, b: int) => int): int {
    return c(5 + 5)
}
callme(toto)*/



test = toto
println(test(1, 2) as string)

