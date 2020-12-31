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

//int atoi( const char * theString ); 
extern atoi(s: string): int

func f(): int {
    print("hello")
}

i: int = atoi("2")
printi(i)

printi(1 > 2)

if (1 > 0) {
    print("1 est plus grand que 0 !")
}
