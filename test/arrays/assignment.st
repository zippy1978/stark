/**
 *  Array assignments tests.
 */

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void
extern failure(): void

struct shop {
    id: int,
    name: string
}

struct shopGroup {
    shops: shop[],
    name: string
}


// Array with primary types
p: int[] = [1, 2, 3]

assertIntEquals(p.len, 3)
assertIntEquals(p[0], 1)
assertIntEquals(p[1], 2)
assertIntEquals(p[2], 3)

// Array with complex types
s1: shop
s1.id = 1
s1.name = "shop 1"

s2: shop
s2.id = 2
s2.name = "shop 2"

shops: shop[] = [s1, s2]

assertIntEquals(shops.len, 2)
assertIntEquals(shops[0].id, 1)
assertIntEquals(shops[0].name.len, 6)
assertIntEquals(shops[1].id, 2)
assertIntEquals(shops[1].name.len, 6)

// Array with complex types, containing arrays
sg: shopGroup
sg.shops = shops
sg.name = "the shop group"

shopGroups: shopGroup[] = [sg]
assertIntEquals(shopGroups.len, 1)
assertIntEquals(shopGroups[0].shops.len, 2)
assertIntEquals(shopGroups[0].shops[0].id, 1)