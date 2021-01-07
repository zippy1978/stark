extern println(s: string): void
extern print(s: string): void
extern printi(i: int): void
extern printd(i: double): void
extern now(): int

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void

struct person {
    age: int,
    name: string
}

p: person
p.age = 12
p.name = "toto"

// Just a point
p2: person = p
// But this reassign
p2.name = "tutu"

s: string = p.name

//l: int = p.name.len.fff
printi(p.age)
println(p.name)
println(s)
println(p2.name)




