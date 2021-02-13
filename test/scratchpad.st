/**
 *  Compiler test : multiple soure files.
 *  company.st
 *  Functions and types 
 */

struct Employee {
    name: string,
    age: int
}

struct Company {
    name: string,
    employees: Employee[]
}

func createEmployee(name: string, age: int): Employee {
    e: Employee
    e.name = name
    e.age = age
    return e
}


/**
 *  Compiler test : multiple soure files.
 *  main.st
 */



    tony: Employee  = createEmployee("Tony Stark", 40)
    pepper: Employee = createEmployee("Pepper Pots", 38)


    starkIndustries: Company
    starkIndustries.name = "Stark Industries"
    starkIndustries.employees = [tony, pepper]

    print("Company: ")
    println(starkIndustries.name)

    print("Number of employees: ")
    println(starkIndustries.employees.len as string)


    println("Employees are:")
    i: int = 0
    while (i < starkIndustries.employees.len) {
        e: Employee = starkIndustries.employees[i]
        g: string = tony.name
        z: int = 1
        print("- ")
        print(e.name)
        print(" (age ")
        print(e.age as string)
        println(")")
        i = i + 1
    }


//starkIndustries.employees[0]

    // Return 0 to show test program has not crashed
    return 2
