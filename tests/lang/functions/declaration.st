/**
 *  Function declartions tests.
 */
 extern assertStringEquals(actual: string, expected: string)

// No arg declaration
func noArg() => void {
}

// Declaration with args
func withArgs(a: int, b: int) => int {
    return a
}

// Omitted return type
func noReturn() {
}

// Declaration with array type return
func arrayReturn() => string[] {
    return ["1", "2"]
}
arrayResult := arrayReturn()
assertStringEquals(arrayResult[1], "2")

// Declaration with array as parameter
func arrayParam(param: string[]) => string {
    return param[0]
}
arrayParamResult := arrayParam(["hello"])
assertStringEquals(arrayParamResult, "hello")