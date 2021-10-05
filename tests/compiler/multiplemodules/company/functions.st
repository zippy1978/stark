/**
 *  Compiler test : multiple modules.
 *  Company module functions
 */
module company

func createEmployee(name: string, age: int) => Employee {
    return Employee(name, age)
}

func createCompany(name: string) => Company {
    return Company(name, null, null)
}