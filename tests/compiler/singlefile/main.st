/**
 *  Compiler test : single main file. 
 *  main.st
 *  Hello world using a function.
 */



func printHello(msg: string) {
    print("Hello ")
    println(msg)
}

func main(args: string[]): int {
    
    if (args.len > 2) {
        printHello(args[1])
    }
    return  0
}