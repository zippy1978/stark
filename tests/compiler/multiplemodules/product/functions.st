/**
 *  Compiler test : multiple modules.
 *  Product module functions
 */
module product

func createProduct(name: string, price: int) => Product {
    return Product(name, price)
}
