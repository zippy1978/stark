/*
 * sratchpad.st
 * A place where language can be tested in real conditions.
*/
extern printi(val: int): void
extern printd(val: double): void
extern print(val: string): void
extern time(): int

//i: int = 10
//printi(i)



// Because when direct : double is passed
// When from binop : point to double is passed !!!
// Pb in method call, or assign ???

// This works : probably an assign pb
//printd(10.0 + 2.0)

/*a: double = 20.0 + 10.0
printd(a)
m: double = 20.0 * 10.0
printd(m)*/

d: double = 10.0 * 2.0
printd(d)
s: string = "test"
print(s)
