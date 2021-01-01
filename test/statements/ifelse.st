/**
 *  If/else statments tests.
 */

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void
extern failure(): void

// Simple if / else on main
if (true) {
    assertTrue(true)
} else {
    failure()
}

// Crash
// Simple if / else in a function
/*func simple(): int {
    if (true) {
        assertTrue(true)
        // Crash ?
        //return 1
    } else {
        failure()
    }
}
simple()*/

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

// Crash
// Nested if / else in a function
/*func test(): int {
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
i: int = test()*/
