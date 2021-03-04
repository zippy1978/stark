/**
 *  Struct declarations tests.
 */

extern assertIntEquals(actual: int, expected: int)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool)
extern failure()

// Struct with primary types
struct Prices {
    wine: int,
    beer: int
}

// Struct with nested complex types
struct Shop {
    name: string,
    prices: Prices
}