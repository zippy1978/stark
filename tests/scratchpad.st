/*
s: (int, int) => int

func add(a: int, b: int): int {
    return a + b
}

s = add

println(s(1, 2) as string)
*/

s: (int[], string) => int

func t(a: int[], b: string): int {
    println(b)
}

s = t
s([1, 2], "f")
/*{
    println("hello")
}*/