extern strtok(str: any, delim: any): any

func split(value: string, separator: string): string[] {
    separatorAsCString := toCString(separator)
    result: string[] = null
    ptr := strtok(toCString(value), separatorAsCString)
    while(ptr != null) {
        if (result == null) {
            result = [fromCString(ptr)]
        } else {
            result = result + [fromCString(ptr)]
        }
        ptr = strtok(null, separatorAsCString)
    }
    return result
}

res := split("hello,world", ",")
i := 0
while (i < res.len) {
    println(res[i])
    i = i +1
}