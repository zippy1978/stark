/**
 *  Function type tests.
 */
extern assertIntEquals(actual: int, expected: int)
extern assertStringEquals(actual: string, expected: string)
extern assertDoubleEquals(actual: double, expected: double)
extern assertTrue(actual: bool)
extern assertFalse(actual: bool)

// Declaration
fn: func (int, int) => int 

// Assignement and call of a standard function
func classical(a: int, b: int) => int {
    return a + b
}
fn = classical
assertIntEquals(fn(1, 2), 3)

// Anonymous function creation and call
add := func (a: int, b: int) => int {
    return a + b
}
assertIntEquals(add(1, 2), 3)

// Anonymous function with array return type
count := func () => int[] {
    return [1, 2, 3]
}
myCount := count()
assertIntEquals(myCount.len, 3)

// Function as parameter to another function
func caller(called: func (int, int) => int) => int {
    return called(1, 2)
}
assertIntEquals(caller(fn), 3)

// Return type is a function
func funcToFunc() => func () => int {
    func () => int {
        12
    }
}
f := funcToFunc()
assertIntEquals(f(), 12)

anonymousFuncToFunc := func () => func () => int {
    func () => int {
        24
    }
}
af := anonymousFuncToFunc()
assertIntEquals(af(), 24)

func funcToFuncToFunc() => func () => func () => int {
    return func () => func () => int {
        return func () => int {
            32
        }
    }
}
ftf := funcToFuncToFunc()
f = ftf()
assertIntEquals(f(), 32)

// Null assignment
fnnull: func (int, int) => int 
fnnull = null
assertTrue(fnnull == null)
assertFalse(fnnull != null)
fnnull = classical
assertFalse(fnnull == null)
assertTrue(fnnull != null)
