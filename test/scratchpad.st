extern println(s: string): void
extern print(s: string): void
extern printi(i: int): void
extern printd(i: double): void
extern now(): int

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void

struct shop {
    id: int,
    name: string
}

struct shopGroup {
    shops: shop[],
    name: string
}

s1: shop
s1.id = 1
s1.name = "shop 1"

s2: shop
s2.id = 2
s2.name = "shop 2"

shops: shop[] = [s1, s2]

sg: shopGroup
sg.shops = shops
sg.name = "the shop group"

shopGroups: shopGroup[] = [sg]

// Crash to fix
assertIntEquals(shopGroups[0].shops[0].id, 1)