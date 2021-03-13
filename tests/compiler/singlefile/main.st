/**
 *  Compiler test : single main file. 
 *  main.st
 *  Hello world using a function.
 */


/*
func printHello(msg: string) {
    print("h")
    //println(msg)
}*/


struct Shop {
    id: int,
    name: string
}

struct ShopGroup {
    shops: Shop[],
    name: string
}

/*
func test(i: int) {

    if (i > 0) {
        println("ok")
    } else {
        println("ko")
    }
}*/

func main(): int {
    s: Shop = Shop(1, "test")
    println(s.name)


    return  0
}