/**
 * C interop functions tests.
 */
 
extern assertIntEquals(actual: int, expected: int)
extern assertDoubleEquals(actual: double, expected: double)
extern assertStringEquals(actual: string, expected: string)
extern assertTrue(actual: bool)

extern atoi(s: any) => int

// toCString
assertIntEquals(atoi(toCString("12")), 12)

// fromCString
assertStringEquals(fromCString(toCString("Hello")), "Hello")

// fromCSubString
assertStringEquals(fromCSubString(toCString("Hello"), 0, 2), "He")