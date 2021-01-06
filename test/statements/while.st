/**
 *  While statements tests.
 */

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void
extern failure(): void

// On main
i: int = 10
while (i > 0) {
    i = i - 1
}
assertIntEquals(i, 0)

// In function
func test(): int {
    i: int = 10
    while (i > 0) {
        i = i - 1
    }
    return i   
}
assertIntEquals(test(), 0)

// In function wih return
func returnTest(): int {
    i: int = 10
    while (i > 0) {
        i = i - 1
        return 20
    }
    return i   
}
assertIntEquals(returnTest(), 20)
