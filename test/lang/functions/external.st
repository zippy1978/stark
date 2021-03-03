/**
 * External functions tests.
 */
 
extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void

// Declaration
extern now(): int
extern atoi(s: string): int

// Usage
assertIntEquals(atoi("12"), 12)
assertTrue(now() > 0)