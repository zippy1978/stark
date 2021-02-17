/**
 *  Compiler test : multiple modules.
 *  Company module types
 */
module company

struct Employee {
    name: string,
    age: int
}

struct Company {
    name: string,
    employees: Employee[]
}