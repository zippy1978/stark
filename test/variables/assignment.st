/**
 *  Variable assignements tests.
 */

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void
extern failure(): void

// Assignment from constant after declaration
var1: int
var1 = 2
assertIntEquals(var1, 2)

// Assignment from constant with declaration
var2: int = 4
assertIntEquals(var2, 4)

// Assignement from other variable
var3: int = 1
var4: int = var3
assertIntEquals(var4, 1)

// Assignement from expression
var5: int = 10 * 5
assertIntEquals(var5, 50)