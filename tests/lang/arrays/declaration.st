/**
 *  Array declarations tests.
 */

extern assertIntEquals(actual: int, expected: int)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool)
extern assertNull(actual: any)
extern failure()

struct Shop {
    id: int,
    name: string
}

// Array with primary types
p: int[]

// Array with complex types
s: Shop[]

// Default array value is an empty array
assertIntEquals(s.len, 0)
