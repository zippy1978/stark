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
