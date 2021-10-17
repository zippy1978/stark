/**
 * Time manipulation utility functions.
 */
//module time

extern localtime(t: any) => any
extern localtime_r(t: any, lt: any)
extern strftime(buffer: any, bufferSize: int, format: any, time: any) => int

/**
 * Time struct.
 */
/*struct Time {
    timeInfo: any
}*/

/**
 * Return Time struct at the current date.
 */
/*func now() => Time {
    return Time(localtime(toIntPointer(time(null))))
}*/

/**
 * Format a Time struct to a string.
 */
func formatTime(time: int, format: string) => string {
    println(time as string)
    timePtr := toIntPointer(time)
    lt := toCString("              ")
    localtime_r(timePtr, lt)
    cstr := toCString(format)
    strftime(cstr, format.len, toCString(format), lt)
    return fromCString(cstr)
}

t := time()
println(formatTime(t, "%H:%M:%S"))

