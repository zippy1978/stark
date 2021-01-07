/**
 *  String type tests.
 */

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void
extern failure(): void

// Assignment 
s: string = "hello"

// Tests length
assertIntEquals(s.len, 5)