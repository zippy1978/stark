/**
 *  String type tests.
 */

extern assertIntEquals(actual: int, expected: int)
extern assertStringEquals(actual: string, expected: string)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool)
extern assertNull(actual: any)
extern failure()

// Assignment 
s: string = "hello"

// Tests length
assertIntEquals(s.len, 5)
assertStringEquals(s, "hello")

// Null assignement
s = null
assertNull(s as any)

// Default value is null
uninitString: string
assertNull(uninitString as any)