/*
 * sratchpad.st
 * A place where language can be tested in real conditions.
*/
extern printi(val: int): void
extern printd(val: double): void
extern print(val: string): void
extern printHello(): void
extern time(): int

func test(i: string): string {
    return i
}
s1: string = test("from func")

// External call does not work (or only with int param)
// Ok
//printi(15)
//time()

// Ko
//print(s1)
printHello()
//printd(20.5)
