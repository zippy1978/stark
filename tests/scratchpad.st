// Return type is a function
func funcToFunc() => func () => int {
    func () => int {
        12
    }
}
f := funcToFunc()
println(f() as string)

anonymousFuncToFunc := func () => func () => int {
    func () => int {
        24
    }
}
af := anonymousFuncToFunc()
println(af() as string)

func funcToFuncToFunc() => func () => func () => int {
    return func () => func () => int {
        return func () => int {
            32
        }
    }
}
ftf := funcToFuncToFunc()
f = ftf()
println(f() as string)
