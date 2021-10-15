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

superMarketPrices := Prices(10, 5)

assertIntEquals(superMarketPrices.wine, 10)
assertIntEquals(superMarketPrices.beer, 5)

// Struct with nested complex types
struct Shop {
    name: string,
    prices: Prices
}

superMarket := Shop("super discount", superMarketPrices)

assertIntEquals(superMarket.name.len, 14)
assertIntEquals(superMarket.prices.wine, 10)
assertStringEquals(superMarket.name, "super discount")

// Struct with function types
struct Operations {
    add: func (int, int) => int,
    sub: func (int, int) => int
}

func add(a: int, b:int) => int {
    return a + b
}
func sub(a: int, b:int) => int {
    return a - b
}

op := Operations(add, sub)

assertIntEquals(op.add(1, 2), 3)
assertIntEquals(op.sub(1, 2), -1)

// Null assignement
superMarket.name = null
assertNull(superMarket.name as any)
superMarket = null
assertNull(superMarket as any)