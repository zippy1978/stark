/**
 *  Compiler test : multiple soure files.
 *  main.st
 */

func main(): int {

    tony: Employee  = createEmployee("Tony Stark", 40)
    pepper: Employee = createEmployee("Pepper Pots", 38)

    starkIndustries := Company("Stark Industries", [tony, pepper])
    
    print("Company: ")
    println(starkIndustries.name)

    print("Number of employees: ")
    println(starkIndustries.employees.len as string)

    println("Employees are:")
    i: int = 0
    while (i < starkIndustries.employees.len) {
        e: Employee = starkIndustries.employees[i]
        print("- ")
        print(e.name)
        print(" (age ")
        print(e.age as string)
        println(")")
        i = i + 1
    }

    return 0
}