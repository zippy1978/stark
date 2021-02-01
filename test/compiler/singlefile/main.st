/**
 *  Compiler test : single main file. 
 *  main.st
 *  Hello world using a function.
 */

func printHello(): void {
    println("hello world")
}

func main(): int {
    printHello()
    return  2
}