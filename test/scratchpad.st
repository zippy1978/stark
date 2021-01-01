/**
 *  If/else statments tests.
 */

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void
extern failure(): void


if (true) {
    assertTrue(true)
} else {
    
}


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
