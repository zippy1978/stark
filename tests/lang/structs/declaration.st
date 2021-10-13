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

struct Customer {
    name: string
}

// Struct with nested complex types
struct Shop {
    name: string,
    prices: Prices,
    customers : Customer[]
}

// Struct with function types
struct Operations {
    add: func (int, int) => int,
    sub: func (int, int) => int,
    sum: func (int[]) => int
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