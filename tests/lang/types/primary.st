/**
 *  Primary types tests.
 */
extern assertIntEquals(actual: int, expected: int)
extern assertStringEquals(actual: string, expected: string)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool)
extern assertFalse(actual: bool)

// int
i: int
// Default value is 0
assertIntEquals(i, 0)

// double
d: double
// Default value is 0.0
assertDoubleEquals(d, 0.0)

// bool
b: bool
// Default value is false (0)
assertFalse(b)