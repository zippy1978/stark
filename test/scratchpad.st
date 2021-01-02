extern print(s: string): void
extern printi(i: int): void
extern printd(i: double): void

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void



func toto(i: int): int {
    if (i < 3) {
        y: int = 0
        y = y + 1
        return y
    } else {
        return 0
    }
    return 12
}
printi(toto(2))
