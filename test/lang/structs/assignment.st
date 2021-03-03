/**
 *  Struct assignments tests.
 */

extern assertIntEquals(actual: int, expected: int): void
extern assertStringEquals(actual: string, expected: string): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void
extern failure(): void

// Struct with primary types
struct Prices {
    wine: int,
    beer: int
}

superMarketPrices: Prices
superMarketPrices.wine = 10
superMarketPrices.beer = 5

assertIntEquals(superMarketPrices.wine, 10)
assertIntEquals(superMarketPrices.beer, 5)

// Struct with nested complex types
struct Shop {
    name: string,
    prices: Prices
}

superMarket: Shop
superMarket.name = "super discount"
superMarket.prices = superMarketPrices

assertIntEquals(superMarket.name.len, 14)
assertIntEquals(superMarket.prices.wine, 10)
assertStringEquals(superMarket.name, "super discount")