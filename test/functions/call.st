

// Delcarations
func func1(): int {
    return 1
}
func func2(a: int, b: double): int {
    z: int = 12 * a
    return func1() + z
}

// For some reason, functions need to be declared at the very top
extern printi(val: int): void

// Calls
// For the moment calling a function before all functions are declared crash
func2(1, 2.0)
func1()

printi(func2(1, 2.0))

func1()