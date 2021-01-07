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


func create(name: string, age: int): person {
    p: person
    p.age = age
    p.name = name

    return p
}

r: person = create("gg", 13)
println(r.name)







