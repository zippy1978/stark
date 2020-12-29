extern printi(val: int): void

// Delcarations
func func1(): int {
    return 1
}
func1()

func func2(a: int, b: double): int {
    z: int = 12 * a
    return func1() + z
}
func2(1, 2.0)

printi(func2(1, 2.0))
