println("This is a simple scratchpad program")

struct Employee {
    name: string,
    age: int
}

struct Company {
    name: string,
    employees: Employee[]
}

mickael: Employee
mickael.name = "Mickael"
mickael.age = 32

david: Employee
david.name = "David"
david.age = 34

insideapp: Company
insideapp.name = "inside|app"
insideapp.employees = [mickael, david]

print("My company is ")
println(insideapp.name)
println("Employees are: ")
i: int = 0
while (i < insideapp.employees.len) {
    print(" - ")
    e: Employee = insideapp.employees[i]
    println(e.name)
    i = i + 1
}
print("Total count is: ")
println(insideapp.employees.len as string)
