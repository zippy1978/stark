/*
 * sratchpad.st
 * A place where language can be tested in real conditions.
*/
extern print(val: string): void
extern printi(val: int): void

func test(): int {
    if (false) {
        print("false")
    } else {
        if (true) {
            // It is ok to land here !
            print("true")
        } else {
            print("false")
        }

    }
    return 12
}
i: int = test()