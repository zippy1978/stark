/**
 *  Compiler test : single main file. 
 *  main.st
 *  Hello world using a function.
 */


func printHello(msg: string) {
    print("hello world ")
    println(msg)
}


func main(): int {
    printHello(null)
    return  0
}