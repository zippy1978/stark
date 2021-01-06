extern print(s: string): void
extern printi(i: int): void
extern printd(i: double): void
extern now(): int

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void



func t(): int {

    start: int = now()
    now: int = now()
    while (true) {
        now = now()
        if (now > 0) {
            return 0
        }
    }
    return 1
}
printi(t())

