// Files
extern fopen(filename: any, accessMode: any ): any
extern fprintf(file: any, format: any): int
extern fclose(file: any): int

// System
extern system(command: any): int
extern sleep(t: int): int

//-----------------------------------------------------------

if (args.len < 2) {
    println("filename is missing")
    return 1
}

filename: string = args[1]
file: any = fopen(toCString(filename), toCString("w"))
if (file == null) {
    println("file cannot be opened")
    return 1
} else {
    fprintf(file, toCString("This was witten from stark !"))
    fclose(file)
}
println("finsihed writting file!")

// In seconds
sleep(1)

if (system(toCString("ls")) != 0) {
    println("cannot run system command")
}
