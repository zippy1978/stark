/*
 * sratchpad.st
 * A place where language can be tested in real conditions.
*/
extern printi(val: int): void
extern printd(val: double): void
extern print(val: string): void
extern time(): int

func test(i: string): string {
    return i
}
s1: string = test("from func")

print(s1)
printi(15)
printd(20.0)