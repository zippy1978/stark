/**
 *  If/else statements tests.
 */

extern assertIntEquals(actual: int, expected: int)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool)
extern failure()

// Simple empty if on main
if (true) {}

// Simple if on main
if (true) {
    assertTrue(true)
}

// Simple if with empty else on main
if (true) {
    assertTrue(true)
} else {}

// Simple if / else on main
if (true) {
    assertTrue(true)
} else {
    failure()
}

// Simple if / else in a function
func simple(): int {
    if (true) {
        assertTrue(true)
        return 1
    } else {
        failure()
    }
}
assertIntEquals(simple(), 1)

// Nested if / else on main
if (true) {
    if (false) {
        failure()
    } else {
        // It is ok to land here !
        assertTrue(true)    
    }
} else {
    failure()
}

// Nested if / else in a function
func nested(): int {
    if (false) {
        failure()
    } else {
        if (true) {
            // It is ok to land here !
            assertTrue(true)
        } else {
            failure()
        }

    }
    return 12
}
assertIntEquals(nested(), 12)

// Return in if statement
func ifReturn(cond: bool): int {
    if (cond) {
        return 1
    }
    return 0
}
assertIntEquals(ifReturn(true), 1)
assertIntEquals(ifReturn(false), 0)

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