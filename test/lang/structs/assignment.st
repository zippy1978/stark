/**
 *  Struct assignments tests.
 */

extern assertIntEquals(actual: int, expected: int)
extern assertStringEquals(actual: string, expected: string)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool)
extern assertNull(actual: any)
extern failure()

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

// Null assignement
superMarket.name = null
assertNull(superMarket.name as any)
superMarket = null
assertNull(superMarket as any)