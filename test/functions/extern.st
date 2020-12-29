extern printi(val: int): void

func test(a: int): int {
    res: int = a * 2
    printi(res)
}

printi(12)
printi(test(2))