/**
 *  Compiler test : multiple modules.
 *  Company module functions
 */
module company

import product

func createEmployee(name: string, age: int): Employee {
    e: Employee
    e.name = name
    e.age = age
    return e
}

func createCompany(name: string): Company {
    c: Company
    c.name = name
    return c
}