extern print(val: string): void
extern printi(val: int): void

// Nested if / else ina function
func test(): int {
    if (1 > 0) {
        print("1 est plus grand que 0 !")
    } else {
        print("faux")

        if (true) {
            print("true")
        } else {
            print(">>>>")
        }

    }
    print("after")
    return 12
}
i: int = test()
printi(i)

// Nested if / else on main
// Use of local variable (because used on sub-block)
if (false) {
    print("never")
    if (1 == 1) {
        print("banana")
    } else {
        print("coconut")
    }
} else {
    printi(i)
    print("always")
}