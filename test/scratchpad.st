/*
 * sratchpad.st
 * A place where language can be tested in real conditions.
*/
extern printi(val: int): void
extern printd(val: double): void
extern print(val: string): void
extern time(): int
extern assertEqual(actual: int, expected: int): void

// Square root function
func sqrt(v: int): int {
    return v * v
}

print("Square root for 4 is")
printi(sqrt(4))

print("Current time is")
printi(time())

print("Good bye !")

//assertEqual(2, 2)

// Crash (logical !!!)
//print("ff" + "dd")