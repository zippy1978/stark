/**
 *  If/else statements tests.
 */

extern assertIntEquals(actual: int, expected: int)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool)
extern failure()



// Return in if statement
func ifReturn(cond: bool): int {
    if (cond) {
        return 1
    }
    return 0
}
assertIntEquals(ifReturn(true), 1)
assertIntEquals(ifReturn(false), 0)


/*
// Return in else statement
func elseReturn(cond: bool): int {
    if (cond) {
        assertTrue(true)
    } else {
        return 1
    }
    return 0
}
assertIntEquals(elseReturn(true), 0)
assertIntEquals(elseReturn(false), 1)
*/