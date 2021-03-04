/**
 * External functions tests.
 */
 
extern assertIntEquals(actual: int, expected: int)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool)

// Declaration
extern now(): int
extern atoi(s: string): int

// Usage
assertIntEquals(atoi("12"), 12)
assertTrue(now() > 0)