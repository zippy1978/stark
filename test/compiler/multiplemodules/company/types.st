/**
 *  Compiler test : multiple modules.
 *  Company module types
 */
module company

import product

struct Employee {
    name: string,
    age: int
}

struct Company {
    name: string,
    employees: Employee[],
    products: product.Product[]
}