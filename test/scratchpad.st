extern castIntToString(i: int): string

println(1)

s: string = castIntToString(12)
println(s)
println(castIntToString(s.len))
i: int = 0
while (i < args.len) {
    println(args[i])
    i = i + 1
}

