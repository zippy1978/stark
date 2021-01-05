extern print(s: string): void
extern printi(i: int): void
extern printd(i: double): void

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void


x: int = 2
func toto(i: int): int {
    
    if (i == 3) {
        return 1
    } else {
        return 5
    }

    //return 4
}
printi(toto(2))
