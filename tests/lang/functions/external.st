/**
 * External functions tests.
 */
 
extern assertIntEquals(actual: int, expected: int)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool)

// Declaration
extern now(): int
extern atoi(s: any): int

// Usage
assertIntEquals(atoi(toCString("12")), 12)
assertTrue(now() > 0)