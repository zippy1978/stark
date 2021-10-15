/**
 * Test module.
 * Used for import testing.
 */
module test

// A struct
struct Test {
    name: string
}

// A function
func addTest(a: int, b: int) => int {
    return a + b
}

// A funtion returning a Test type
func returnTest() => Test {
    return Test("this is a test")
}

// Empty function (no return)
func empty() {
    
}

// Nested functions
func withNestedFunx() {
    // Primary type
    f1 := func (a: int) {
        b := a * 2
    }
    f1(2)
    // Array type
    f2 := func (a: int[]) {
        b := a[0] * 2
    }
    f2([3])
    // Function type
    f3 := func (a: func() => int) {
        b := a()
    }
    f3(func() => int {2})
    // Struct
    f4 := func (a: Test) => Test {
        a
    }
}

// Function with function signature
func sig(c: func () => int) {
    
}