/**
 * Binary expressions tests.
 */

extern assertIntEquals(actual: int, expected: int)
extern assertDoubleEquals(actual: double, expected: double)
extern assertStringEquals(actual: string, expected: string)
extern assertTrue(actual: bool)
extern assertFalse(actual: bool)

// Add
assertIntEquals(1 + 2, 3)
assertDoubleEquals(2.5 + 10.5, 13.0)

// Sub
assertIntEquals(2 - 1, 1)
assertDoubleEquals(10.0 - 2.5, 7.5)

// Mul
assertIntEquals(2 * 2, 4)
assertDoubleEquals(10.0 * 2.5, 25.0)

// Div
assertIntEquals(6 / 2, 3)
assertDoubleEquals(5.0 / 2.0, 2.5)

// With parents
assertIntEquals(((6 / 2 ) * 3) - 1, 8)
assertDoubleEquals(5.0 / 2.0, 2.5)

// Multiple variables
three: int = 1 + 2
six: int = 3 * 2
assertIntEquals(three + six, 9)
fiveTwo: double = 1.0 + 4.2
fourHeight: double = 2.4 * 2.0
assertDoubleEquals(fiveTwo + fourHeight, 10.0)

// Bool operators
assertTrue(true && true)
assertFalse(true && false)
assertTrue(true || false)
assertFalse(false || false)

// String concatenation
s1 := "hello "
s2 := "world !"
stringConcat := s1 + s2
assertStringEquals(stringConcat, "hello world !")
assertIntEquals(stringConcat.len, 13)

// Array concatenation
a1 := [1, 2]
a2 := [3, 4]
arrayConcat := a1 + a2
assertIntEquals(arrayConcat[2], 3)
assertIntEquals(arrayConcat.len, 4)
sa1 := ["hello", "world"]
sa2 := ["be", "happy"]
stringArrayConcat := sa1 + sa2
assertStringEquals(stringArrayConcat[3], "happy")
assertIntEquals(stringArrayConcat.len, 4)