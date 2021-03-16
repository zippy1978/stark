# Common programming concepts

Like other languages, Stark is built on common basic concepts such as variables, types, functions...

You will see that Stark looks like many other languages at its core, but still it is important to know how things work to get the most out of it.

## Variables

Variables are used to store values during the program execution. They all have a type, a value and a scope.

### Declaration

The variable declaration syntax is:

*name*: *type* [= *value*]

Here are some examples :

```stark
// A variable named counter of type int
counter: int
// A variable named message of type string initialized with a string litteral
message: string = "Hello from Stark lang !"

// When assigned directly, type can be omitted, it is inferred by the assigned value
anotherMessage := "Hello, I'm inferred !"
```

!> For the moment, an uninitialized variable has not default value. This will change in the future.

### Assignment

Variables are mutable by default. That means that they can be re-assigned if needed:

```stark
// counter variable is initialized with 0
counter := 0
// Then reassigned (and is now 5)
counter = 2 + 3
```

### Scope

Variables are local to the code block they are declared in: they can be accessed by nested blocks, but not by parent blocks.

In this example, *result* variable is accessible from the *if* block:
```stark
func amIOld(age: int): string {
    result := "No you are young !"
    if (age > 50) {
        result = "Sorry, you are old"
    }
    return result
}
println(amIOld(42))
```

Program will run without error:

```bash
$ stark example.st
No you are young !
```

However, the example bellow will not work because *result* is declared in *if* and *else* block, and is not known to the function block.

```stark
func amIOld(age: int): string {
    if (age > 50) {
        result := "Sorry, you are old"
    } else {
        result := "No you are young !"
    }
    return result
}
println(amIOld(42))
```

```bash
$ stark example.st
example.st:7:1 error: undeclared identifier result
```

## Data types

In Stark, every value is typed.

They are 2 kinds of data types : primary types and complex types.

### Primary types

Primary types are basic builtin types (all numeric). They are allocated on the stack.

| Name          | Description   |
| ------------- |---------------|
| int           | Integer value |
| double        | Decimal value |
| bool          | Boolean value |


#### Binary operations

Primary types support binary operations when operand are of the same type:

Available operators are :

| Syntax        | Description   |
| ------------- |---------------|
| +             | Addition      |
| -             | Substraction  |
| *             | Multiplication|
| /             | Division      |
| &&            | And           |
| ||            | or            |


```stark
// This works
a: int = 3
b: int = 2 * a

// This does not work
c: double = 10.0
d: int = 4 - c
```

?> In order to support operations with different primary types, use the conversion operator as explained below.

#### Comparisons

Primary types also support comparisons (again both operand must be of the same type).

Available comparisons are :

| Syntax        | Description      |
| ------------- |------------------|
| ==            | Equals           |
| !=            | Not equal        |
| >             | Greater than     |
| >=            | Greater or equals|
| <             | Lower than       |
| <=            | Lower or equals  |

#### The void type

The *void* type is a special primary type used to mark the absence of value. It cannot be assigned, and is primarly used for functions without a return type.

### Complex types

Complex types are types holding more than one value. They are allocated on the heap, and they can have a null value.

Complex types include:

- strings
- arrays
- structs (custom types)

### The string type

The *string* type is a specific builtin complex type.

It can be initialized with a litteral, and its *len* member can be used to retrieve its length (number of characters):

```stark
s: string = "This is my string"
l: int = s.len
```

String litterals support escape sequences. Escape sequences are used to represent certain special characters within string literals.

Supported escape sequences are:

| Escape sequence | Description          |
| --------------- |----------------------|
| \'              | Single quote         |
| \"              | Double quote         |
| \\              | Backslash.           |
| \a              | Audible bell         |
| \b              | Backspace            |
| \f              | Form feed            |
| \f              | Form feed            |
| \n              | Line feed - new line |
| \r              | Carriage return      |
| \t              | Horizontal tab       |
| \v              | Vertical tab         |

Some examples:

```stark
println("line1\nline2")
// line1
// line2
println("trees: \t🌲\t🌲\t🌲")
// trees: 	🌲	🌲	🌲
println("beers: \t🍺\t🍺\t🍺")
// beers: 	🍺	🍺	🍺
```

### Type conversion

A value of some type can be converted to antoher type using the *as* operator.

Conversion is only supported on primary types and string, and only if the conversion does not cause a data loss:

```stark
i: int
d: double
s: string

// Convert an int to a double
i = 12
d = i as double

// Convert an int to a string
i = 20
s = i as string

// Convert a string to a double
s = "14.5"
d = s as double

```

?> When a string cannot be converted to a primary type, the returned value is 0 (false for a bool)

### The any type

The *any* type is, like void, a special primary type used to represent any kind of complex type. It cannot be created from code, and is mainly used to interract with C functions pointers. Under the hood, *any* is an anonymous pointer.

```stark
// Here 'any' is used to materialize C pointers: char* and FILE*
extern fopen(filename: any, accessMode: any): any
extern fprintf(file: any, format: any): int
extern fclose(file: any): int

filename: string = "output"

// toCString is a builtin runtime function 
// used to convert a Stark string to a C string (char *) 
file: any = fopen(toCString(filename), toCString("w"))
if (file == null) {
    println("file cannot be opened")
    return 1
} else {
    fprintf(file, toCString("This was witten from Stark !"))
    fclose(file)
}
```

### Nullability

Complex types can be assigned null values, to mark the abscence of value on a variable.

```stark
s: string = "A string value"
s = null
if (s == null) {
  println("s is null")
}
```

## Functions

Functions are callable code blocks taking values as input (parameters), and outputting a result value.

### Declaration

The function definition syntax is:

**func** *name*(*paramname*: *type*, *paramname*: *type*, ...): *type* {...}

A *return* statement is expected inside the function body, except if the return type is *void*:

```stark
func add(a: int, b: int): int {
    return a + b
}

func sayHello(): void {
    println("Hello")
    // No need to return here
}

// When return type is void, it can be omitted
func noReturn() {
   println("This function has no return")
}
```

### Call

Once defined, a function can be called with the syntax:

*name*(*paramname*: *type*, *paramname*: *type*, ...)

```stark
result: int = add(3, 7)
sayHello()
```

## Comments

Stark supports single line and multiline comments:

```stark
// This is a single line comment
i: int = 10

/* This is
 * a multiline
 * comment
 */
 d: double = 12.5
```

## Control flow

### Conditions

Conditions are expressed with if / else blocks, using the syntax:

*if*(*condition*) {*...*} [*else* {*...*}]

Here are a few example:

```stark
i: int = 5

// If / else block
if (i > 4) {
  println("i is greater than 4")
} else {
  println("i is lower than or equals 4")
}

// Single if
if (i == 5) {
    println("i equals 5")
}
```

### Loops

In Stark loops are defined using a *while* statement:

*while*(*condition*) {*...*}

The *while* statement will loop on the block until the condition returns false:

```stark
i: int = 0

// Count from 0 to 9
while (i < 10) {
    println(i as string)
    i = i + 1
}
```