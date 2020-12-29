// Delcarations
func func1(): int {}
func func2(a: int, b: double): int {
    z: int = 12
    func1()
}

// Calls
// For the moment calling a function before all functions are declared crash
func1()
func2(1, 2.0)

