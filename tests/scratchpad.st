
if (args.len > 1) {
    concat := "hello " + args[1]
    println(concat + " (" + concat.len as string + ")")
} else {
    println("unkown")
}