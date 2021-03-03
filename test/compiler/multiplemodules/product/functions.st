/**
 *  Compiler test : multiple modules.
 *  Product module functions
 */
module product

func createProduct(name: string, price: int): Product {
    p: Product
    p.name = name
    p.price = price
    return p
}
