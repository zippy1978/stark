extern println(s: string): void
extern printi(i: int): void
extern printd(i: double): void
extern now(): int

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void



s: string = "coucou"

l: int = s.len
printi(l)

println(s)

