extern printi(val: int): void
extern print(val: string): int
extern time(): int

/*
 * sratchpad.st
 * A place where language can be tested in real conditions.
*/

/*func sqrt(num: int): int {
    return num * num
}*/

// Print squared root of 4
//printi(sqrt(4))

// Print current time
//printi(time())

// String asignment is crashing
//str: string = "ff"
// Maybe a leak here !
//str = "gg\n"
//printf("Hello, I support strings now !!!")
//printf(str)

// Crash
//print("str")
//print(str)

s: string = "test"
printf(s)
print(s)


