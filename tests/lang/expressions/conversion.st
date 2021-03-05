/**
 * Conversion expressions tests.
 */

extern assertStringEquals(actual: string, expected: string)
extern assertDoubleEquals(actual: double, expected: double)
extern assertIntEquals(actual: int, expected: int)
extern assertTrue(actual: bool)

// int
i: int = 34
// To int
assertIntEquals(i as int, 34)
// To double
assertDoubleEquals(i as double, 34.0)
// To string
assertStringEquals(i as string, "34")

// double
d: double = 12.123
// To double
assertDoubleEquals(d as double, 12.123)
// To string
assertStringEquals(d as string, "12.123000")

// bool
b: bool = true
// To int
assertIntEquals(b as int, 1)
// To double 
assertDoubleEquals(b as double, 1.0)
// To string
assertStringEquals(b as string, "true")
// To bool
assertTrue(b as bool)

// string
// To int
si: string = "12"
assertIntEquals(si as int, 12)
// To double
sd: string = "34.5"
assertDoubleEquals(sd as double, 34.5)
// To string
ss: string = "hello"
assertStringEquals(ss as string, "hello")
// To bool
sb: string = "true"
assertTrue(sb as bool)