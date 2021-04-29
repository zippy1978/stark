# Common programming concepts

Like other languages, Stark is built on common basic concepts such as variables, types, functions...

You will see that Stark looks like many other languages at its core, but still it is important to know how things work to get the most out of it.

## Variables

Variables are used to store values during the program execution. They all have a type, a value and a scope.

### Declaration

The variable declaration syntax is:

``name``: ``type`` [= ``value``] 

``name``:= ``value``

Here are some examples :

```stark
// A variable named counter of type int
counter: int
// A variable named message of type string initialized with a string litteral
message: string = "Hello from Stark lang !"

// When assigned directly, type can be omitted, it is inferred by the assigned value
anotherMessage := "Hello, I'm inferred !"
```

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

When uninitialized, a primary type variable always has a default value.

| Name          | Description   | Default value |
| ------------- |---------------|---------------|
| int           | Integer value |0              |
| double        | Decimal value |0.0            |
| bool          | Boolean value |false          |

#### The void type

The ``void`` type is a special primary type used to mark the absence of value. It cannot be assigned, and is primarly used for functions without a return type.

### Complex types

Complex types are types holding more than one value. They are allocated on the heap, and they can have a null value.

Complex types include:

| Name                 | Description     | Default value |
| -------------------- |-----------------|---------------|
| string               | String value    |Empty string   |
| arrays               | Array of values |Empty array    |
| struct (custom types)| Custom data     |null           |

### The string type

The ``string`` type is a specific builtin complex type.

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

#### Binary operations

Binary operations are supported for primary types when operand are of the same type.

Complex types (some of them) also support some of them.

Available operators are :

| Syntax        | Description   | Complex type support           |
| ------------- |---------------| -------------------------------|
| +             | Addition      | string only: concatenation     |
| -             | Substraction  | Not supported                  |
| *             | Multiplication| Not supported                  |
| /             | Division      | Not supported                  |
| &&            | And           | Not supported                  |
| ||            | or            | Not supported                  |


```stark
// This works
a: int = 3
b: int = 2 * a

// This does not work
c: double = 10.0
d: int = 4 - c

// string concatenation
s1 := "hello"
s2 := "world"
concat := s1 + " " + s2
```

?> In order to support operations with different primary types, use the conversion operator ``as`` explained below.


### Comparisons

Values can be compared using comparison operators. Comparisons are only supported when both operand are of the same type.

Primary types support all comparison operators, as complex types can only support some operators.

Available comparisons for complex types are :

| Syntax        | Description      | Complex type support                              |
| ------------- |------------------|-------------------------------------------------- |
| ==            | Equals           | Only with null as other operand, or with 2 strings|
| !=            | Not equal        | Only with null as other operand, or with 2 strings|
| >             | Greater than     | Not supported                                     |
| >=            | Greater or equals| Not supported                                     |
| <             | Lower than       | Not supported                                     |
| <=            | Lower or equals  | Not supported                                     |

```stark
// Returns true
r := 2 > 1

// Returns false
s: string
r2 := (s != null)

// Returns true
s1 := "same"
s2 := "same"
r3 := (s1 == s2)

```

### Type conversion

A value of some type can be converted to antoher type using the ``as`` operator.

Conversion is only supported on primary types and ``string``, and only if the conversion does not cause a data loss:

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

?> When a ``string`` cannot be converted to a primary type, the returned value is 0 (false for a ``bool``)

### The any type

The ``any`` type is, like ``void``, a special primary type used to represent any kind of complex type. It cannot be created from code, and is mainly used to interract with C functions pointers. Under the hood, ``any`` is an anonymous pointer.

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

Complex types can be assigned ``null`` values, to mark the abscence of value on a variable.

```stark
s: string = "A string value"
s = null
if (s == null) {
  println("s is null")
}
```

!> Be careful when handling ``null`` assigned variables, it may result in unexpected behaviors, or, more often, crashes (SEGFAULT).

## Functions

Functions are callable code blocks taking values as input (parameters), and outputting a result value.

### Declaration

The function definition syntax is:

func ``name``(``paramname``: ``type``, ``paramname``: ``type``, ...): ``type`` {...}

A ``return`` statement is expected inside the function body, except if the return type is ``void``:

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

``name``(``param``, ``param``, ...)

Parameters must match the function declaration (count and position).

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

Stark supports a few control flow instructions.

### Conditions

Conditions are expressed with ``if`` / ``else`` blocks, using the syntax:

if(``condition``) {...} [else {...}]

The condition can be any expression resolving to a ``bool`` value.

Here are a few example:

```stark
i := 5

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

In Stark loops are defined using a ``while`` statement:

while(``condition``) {*...*}

As for ``if``, condition can be any expression resolving to a ``bool`` value.

The ``while`` statement will loop on the block until the condition returns ``false``:

```stark
i := 0

// Count from 0 to 9
while (i < 10) {
    println(i as string)
    i = i + 1
}
```