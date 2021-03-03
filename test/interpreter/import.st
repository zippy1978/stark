/**
 *  Import with interpreter tests.
 */
// Import test module
import test

extern assertIntEquals(actual: int, expected: int): void
extern assertStringEquals(actual: string, expected: string): void

// Call function, calling a module function
func anotherFunc(): int {
    return test.addTest(1, 2)
}
assertIntEquals(anotherFunc(), 3)

// Use a type defined in the module
t: test.Test
t.name = "ok"

// Call a module function returning a type defined in the module
t2: test.Test = test.returnTest()
assertStringEquals(t2.name, "this is a test")

