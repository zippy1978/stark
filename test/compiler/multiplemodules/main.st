import company

func main(): int {
    //println("todo : call modules")
    company.createEmployee("Gilles", 42)
    
    // Should fail after struct export is ok
    e: Employee
    e.name = "Gillou"
    
    println(e.name)
    return 0
}