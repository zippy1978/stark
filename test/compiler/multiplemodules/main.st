import company

func main(): int {
    //println("todo : call modules")
    //createEmployee("Gilles", 42)
    
    // Should fail after struct export is ok
    e: Employee
    e.name = "Gillou"
    
    // For successful test result : return 2
    println(e.name)
    return 2
}