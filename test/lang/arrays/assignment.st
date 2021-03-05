/**
 *  Array assignments tests.
 */

extern assertIntEquals(actual: int, expected: int)
extern assertStringEquals(actual: string, expected: string)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool): void
extern failure(): void

struct Shop {
    id: int,
    name: string
}

struct ShopGroup {
    shops: Shop[],
    name: string
}


// Array with primary types
p: int[] = [1, 2, 3]

assertIntEquals(p.len, 3)
assertIntEquals(p[0], 1)
assertIntEquals(p[1], 2)
assertIntEquals(p[2], 3)

// Array with complex types
s1: Shop
s1.id = 1
s1.name = "shop 1"

s2: Shop
s2.id = 2
s2.name = "shop 2"

shops: Shop[] = [s1, s2]

assertIntEquals(shops.len, 2)
assertIntEquals(shops[0].id, 1)
assertIntEquals(shops[0].name.len, 6)
assertStringEquals(shops[0].name, "shop 1")
assertIntEquals(shops[1].id, 2)
assertIntEquals(shops[1].name.len, 6)
assertStringEquals(shops[1].name, "shop 2")

// Array with complex types, containing arrays
sg: ShopGroup
sg.shops = shops
sg.name = "the shop group"

shopGroups: ShopGroup[] = [sg]
assertIntEquals(shopGroups.len, 1)
assertIntEquals(shopGroups[0].shops.len, 2)

assertIntEquals(shopGroups[0].shops[0].id, 1)
assertIntEquals(shopGroups[0].shops[1].id, 2)
assertStringEquals(shopGroups[0].shops[0].name, "shop 1")
assertStringEquals(shopGroups[0].shops[1].name, "shop 2")

// One line declaration
oneLineInt := [1, 2]
assertIntEquals(oneLineInt.len, 2)
oneLineShops := shops
assertIntEquals(oneLineShops.len, 2)
assertStringEquals(oneLineShops[0].name, "shop 1")