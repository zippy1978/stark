/**
 *  Array declarations tests.
 */

extern assertIntEquals(actual: int, expected: int)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool)
extern failure()

struct Shop {
    id: int,
    name: string
}

// Array with primary types
p: int[]

// Array with complex types
s: Shop[]

