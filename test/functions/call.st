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

// Not working at the moment : recursive calls (the function does not know itself yet !)
/*func recursive(i: int): int {
    if (i == 0) {
        return i
    } else {
        return recursive(i - 1)
    }
}
assertIntEquals(recursive(10), 0)*/