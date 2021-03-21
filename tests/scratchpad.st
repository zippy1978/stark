struct ShopGroup {
    name: string
}

uninitArray: ShopGroup[]
uninitArray as any
if (uninitArray == null) {
    println("is null")
}