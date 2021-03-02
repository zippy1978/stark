import company

func main(): int {
    e: Company.Employee = company.createEmployee("Gilles", 42)
    println(e.name)
    return 0
}