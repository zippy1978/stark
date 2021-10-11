
struct Test {
    name: string
}

func f() => Test[] {
    return [Test("one"), Test("two")]
}
r := f()
println(r[1].name)