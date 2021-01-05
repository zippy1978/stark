extern print(s: string): void
extern printi(i: int): void
extern printd(i: double): void

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void


cont: int = 10
while (cont > 0) {
    printi(cont)
    if (cont == 7) {
        print("my favourite num !!!")
    }
    cont = cont - 1
}

