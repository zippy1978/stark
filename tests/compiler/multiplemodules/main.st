import company

func main() => int {
    e := company.createEmployee("Gilles", 42)
    println(e.name)
    // Also try invoking a cosntructor from a module type
    f := company.Employee("Albert", 60)
    return 0
}