/**
 *  Struct assignments tests.
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

superMarketPrices: prices
superMarketPrices.wine = 10
superMarketPrices.beer = 5

assertIntEquals(superMarketPrices.wine, 10)
assertIntEquals(superMarketPrices.beer, 5)

// Struct with nested complex types
struct shop {
    name: string,
    prices: prices
}

superMarket: shop
superMarket.name = "super discount"
superMarket.prices = superMarketPrices

assertIntEquals(superMarket.name.len, 14)
assertIntEquals(superMarket.prices.wine, 10)