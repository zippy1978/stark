/**
 *  Function type tests.
 */
extern assertIntEquals(actual: int, expected: int)
extern assertStringEquals(actual: string, expected: string)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool)
extern assertFalse(actual: bool)

// Declaration
fn: (a: int, b: int) => int 

// Assignement
func classical(a: int, b: int): int {
    return a + b
}
fn = classical

// Call
assertIntEquals(fn(1, 2), 3)