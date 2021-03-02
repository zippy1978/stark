println("test")
struct ff {
    t: int,
    n: string
}

func test(g: ff): void {
    println(g.n)
}

f: ff
f.n = "hello"
test(f)