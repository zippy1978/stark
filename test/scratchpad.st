/*
 * sratchpad.st
 * A place where language can be tested in real conditions.
*/
extern printi(val: int): void
extern printd(val: double): void
extern print(val: string): void
extern time(): int
extern assertEqual(actual: int, expected: int): void
extern assertTrue(actual: bool): void

func f(): int {
    print("hello")
}
