/**
 *  Function calls tests.
 */

extern assertIntEquals(actual: int, expected: int)
extern assertNull(actual: any)

// No arg
func noArg() => void {
}
noArg()

// With args
func withArgs(a: int, b: int) => int {
    return a
}
assertIntEquals(withArgs(2, 1), 2)

// Recursive function call
func fib(x: int) => int {
    if (x < 3) {
        return 1
    } else {
        return fib(x - 1) + fib(x - 2)
    }
}
assertIntEquals(fib(9), 34)

// Null return
func echoString(s: string) => string {
    return s
}
assertNull(echoString(null) as any)