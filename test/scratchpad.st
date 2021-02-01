struct Employee {
    name: string,
    age: int
}

struct Company {
    name: string,
    employees: Employee[] // this is bad !
    //test: int[]
    
}

func createEmployee(name: string, age: int): Employee {
    e: Employee
    e.name = name
    e.age = age
    return e
}

tony: Employee  = createEmployee("Tony Stark", 40)
pepper: Employee = createEmployee("Pepper Pots", 38)

starkIndustries: Company
starkIndustries.name = "Stark Industries"
starkIndustries.employees = [tony, pepper] // as soon as array is init : string is broken !
//starkIndustries.test = [1, 2] // works with int

// Problem with array alloc or string alloc
// Or in element index resolution
// Or in struct declaration


print("Company: ")
println(starkIndustries.name)

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


struct Test {
    s1: string,
    s2: string,
    sa: string[],
    e: Employee[]
}

t: Test
t.s1 = "s111111111111111111111111111111"
t.s2 = "s222222222222222222222222222222"
t.sa = ["abc", "def"]
t.e = [tony, pepper]
println(t.s1)
println(t.s2)
println(t.sa[0])
println(t.sa[1])


// Problem lies with array size for complex types !!!
// Works if I double allocated size !