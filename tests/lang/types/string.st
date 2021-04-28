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
assertIntEquals(s.len, 5)
assertStringEquals(s, "hello")

// Null assignement
s = null
assertNull(s as any)

// Default value is an empty string
uninitString: string
assertIntEquals(uninitString.len, 0)

// Concatenation
s1 := "hello "
s2 := "world !"
concat := s1 + s2
assertStringEquals(concat, "hello world !")
assertIntEquals(concat.len, 13)