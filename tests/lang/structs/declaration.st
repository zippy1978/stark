/**
 *  Struct declarations tests.
 */

extern assertIntEquals(actual: int, expected: int)
extern assertDoubleEquals(actual: double, expected: double)
extern assertStringEquals(actual: string, expected: string)
extern assertTrue(actual: bool)
extern failure()

// Struct with primary types
struct Prices {
    wine: int,
    beer: int
}

// Struct with nested complex types
struct Shop {
    name: string,
    prices: Prices
}

// Nested type declaration
struct Node {
    name: string,
    parent: Node
}

parent := Node("parent", null)
child := Node("child", parent)
assertStringEquals(child.parent.name, "parent")

// Forward declaration
struct ForwardType

struct UseForwardType {
    type: ForwardType
}

struct ForwardType {
    name: string
}

uft := UseForwardType(ForwardType("test"))
assertStringEquals(uft.type.name, "test")