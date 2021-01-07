/**
 *  Struct declarations tests.
 */

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void
extern failure(): void

// Struct with primary types
struct prices {
    wine: int,
    beer: int
}

// Struct with nested complex types
struct shop {
    name: string,
    prices: prices
}