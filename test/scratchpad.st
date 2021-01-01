/*
 * sratchpad.st
 * A place where language can be tested in real conditions.
*/
extern print(val: string): void
extern printi(val: int): void

/*extern printd(val: double): void
extern time(): int
extern assertEqual(actual: int, expected: int): void
extern assertTrue(actual: bool): void
extern atoi(s: string): int*/


// Crash
/*func t(val: int): int {
    r: int = 0
    if (val > 10) {
        r = val
    } else {
        r = val * -1
    }
    //return r
}*/
//printi(t(3))

x: int = 10
func t(): int {
    return x
}
printi(t())