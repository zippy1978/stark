/**
 *  If/else statements tests.
 */

extern assertIntEquals(actual: int, expected: int)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool)
extern failure()


// BROKEN
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


// BROKEN
// Nested if / else in a function
/*func nested(): int {
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
assertIntEquals(nested(), 12)*/