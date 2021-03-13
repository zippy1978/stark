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


s1: Shop = Shop(1, "shop 1")
s2: Shop = Shop(2, "shop 2")
shops: Shop[] = [s1, s2]

// Array with complex types, containing arrays
sg: ShopGroup = ShopGroup(shops, "the shop group")

shopGroups: ShopGroup[] = [sg]


// Crash here !!!
// Nested array case !
shopGroups[0].shops.len

// This works 
shopGroups[0].shops

//assertIntEquals(shopGroups[0].shops.len, 2)





//assertIntEquals(shopGroups[0].shops[0].id, 1)
//assertIntEquals(shopGroups[0].shops[1].id, 2)
//assertStringEquals(shopGroups[0].shops[0].name, "shop 1")
//assertStringEquals(shopGroups[0].shops[1].name, "shop 2")
