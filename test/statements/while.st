/**
 *  While statements tests.
 */

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void
extern failure(): void

i: int = 10
while ( i > 0) {
    i = i - 1
}
assertIntEquals(i, 0)