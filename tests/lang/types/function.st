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

// Function as parameter to another function
func caller(called: (a: int, b: int) => int): int {
    return called(1, 2)
}
assertIntEquals(caller(fn), 3)

// Null assignment
fnnull: (a: int, b: int) => int 
fnnull = null
assertTrue(fnnull == null)
assertFalse(fnnull != null)
fnnull = classical
assertFalse(fnnull == null)
assertTrue(fnnull != null)
