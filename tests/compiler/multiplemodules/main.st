import company

func main(): int {
    e: company.Employee = company.createEmployee("Gilles", 42)
    println(e.name)
    return 0
}