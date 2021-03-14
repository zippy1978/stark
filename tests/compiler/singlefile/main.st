/**
 *  Compiler test : single main file. 
 *  main.st
 *  Hello world using a function.
 */



func printHello(msg: string) {
    print("Hello ")
    println(msg)
}

func main(): int {
    
    printHello("Tony")
    return  0
}