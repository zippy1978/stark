/**
 *  Struct declarations tests.
 */

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void
extern failure(): void

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