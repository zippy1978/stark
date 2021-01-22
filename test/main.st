// From runtime
extern println(s: string): void

// From module
extern echo(s: string): string

func main(): int {
    a: string = "gg"
    println(echo(a))
    return  0
}