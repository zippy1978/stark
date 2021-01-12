/**
 *  Array declarations tests.
 */

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void
extern failure(): void

struct shop {
    id: int,
    name: string
}

// Array with primary types
p: int[]

// Array with complex types
s: shop[]

