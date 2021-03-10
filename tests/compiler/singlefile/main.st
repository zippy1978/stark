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

/*
struct Shop {
    id: int,
    name: string
}

struct ShopGroup {
    shops: Shop[],
    name: string
}*/

/*
func test(i: int) {

    if (i > 0) {
        println("ok")
    } else {
        println("ko")
    }
}*/

func main(): int {
    //s: string = null
    //s := "ff"
    //printHello("d")
    //println(s.len as string)
    //s.len
    //p: int[] = [1, 0, 3]
    //s: Shop
    //s.id = 1
    //s.name = "test"
    //i:int = p[0] + 1
    //test(p[1])
    
    //x: int[]
    t: string[] = ["a", "gilles"]
    
    // TODO : fix this, member lookup should return a string* !
    t[1] = "ok"
    println(t[1])
    
    // this is ok
    //println(t.len as string)


    return  0
}