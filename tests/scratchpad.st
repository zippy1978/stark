struct Shop {
    id: int,
    name: string
}

s: Shop = Shop(1, "test")
//s.name = "ff"

// this does not work !!!
//println(s.name.len as string)
println(s.name)