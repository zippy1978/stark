func meth(): int {
    return 1
}

struct Me {
    meth: () => int
}

m := Me(meth)
println(m.meth() as string)


