import test

extern assertIntEquals(actual: int, expected: int): void

func anotherFunc(): int {
    return test.addTest(1, 2)
}

assertIntEquals(anotherFunc(), 3)
