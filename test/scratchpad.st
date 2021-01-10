extern println(s: string): void
extern print(s: string): void
extern printi(i: int): void
extern printd(i: double): void
extern now(): int

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void


struct trooper {
    name: string,
    serial: int
}

t1: trooper
t1.name = "t1"
t1.serial = 12

t2: trooper
t2.name = "t2"
t2.serial = 2

army: trooper[] = [t1, t2]
printi(army[0].serial)



a: int[] = [1, 2, 3]
printi(a[1])