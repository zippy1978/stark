func amIOld(age: int): string {
    if (age > 50) {
        result: string = "Sorry, you are old"
    } else {
        result: string = "No you are young !"
    }
    return result
}
println(amIOld(42))