extern println(s: string): void
extern print(s: string): void
extern printi(i: int): void
extern printd(i: double): void
extern now(): int

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void

print("arg count is ")
printi(args.len)
println("args are: ")
i: int = 0
while (i < args.len) {
    println(args[i])
    i = i + 1
}
