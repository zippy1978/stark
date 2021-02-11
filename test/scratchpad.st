
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
