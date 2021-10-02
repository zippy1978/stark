func meth(): int {
    println("called")
    return 1
}

t : () => int[]
t = [meth]
t = t + [meth]


f : () => int
f = t[0] 
t[0]()

struct Parent {
    m : () => int[]
}

p := Parent(t)
p.m[0]()

// FIXME
// store a function into an array
// call a function from an array (nested members)

func classical(a: int, b: int): int {
    return a + b
}

// Nested call
struct Struct {
    function: (a: int, b: int) => int
}
s := Struct(classical)
s.function(1, 2)
