
// Still need to add this !
// Linker should take care of adding this automatically between file of the same module !
extern returnOne(): int

func main(): int {
    return returnOne()   
}