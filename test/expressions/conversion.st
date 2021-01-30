/**
 * Conversion expressions tests.
 */

extern assertStringEquals(actual: string, expected: string): void
extern assertDoubleEquals(actual: double, expected: double): void

// int
i: int = 34
// to string
assertStringEquals(i as string, "34")
// to double
assertDoubleEquals(i as double, 34.0)

// double
d: double = 12.123
// to string
assertStringEquals(d as string, "12.123000")