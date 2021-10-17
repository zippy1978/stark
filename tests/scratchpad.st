extern assertStringEquals(a: string, e: string)


a := "abcdefg"

slice: string
slice.data = offsetCharPointer(a.data, 1)
slice.len = a.len - 1
println(slice)
assertStringEquals(slice, "bcdefg")