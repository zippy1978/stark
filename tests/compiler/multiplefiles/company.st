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
    return Employee(name, age)
}
