/**
 *  Function calls tests.
 */

extern assertIntEquals(actual: int, expected: int): void

// No arg declaration
func noArg(): void {
}
noArg()


// Declaration with args
func withArgs(a: int, b: int): int {
    return a
}
assertIntEquals(withArgs(2, 1), 2)

if (true) {
    println("ok")
}

// Recursive function call
func fib(x: int): int {
    if (x < 3) {
        return 1
    } else {
        return 0
        //return fib(x - 1) + fib(x - 2)
    }
}
//assertIntEquals(fib(9), 34)
