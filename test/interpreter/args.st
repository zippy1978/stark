/**
 *  Args injection with interpreter tests.
 */

extern assertStringEquals(actual: string, expected: string): void
extern assertIntEquals(actual: int, expected: int): void

// Test args count (includes program file as first arg)
assertIntEquals(args.len, 3)

// Test args values
assertStringEquals(args[1], "arg1")
assertStringEquals(args[2], "arg2")