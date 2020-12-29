extern printi(val: int): void
extern time(): int

/*
 * sratchpad.st
 * A place where language can be tested in real conditions.
*/

func sqrt(num: int): int {
    return num * num
}

// Print squared root of 4
printi(sqrt(4))

// Print current time
printi(time())


