# Modules

Modules are Stark code units.

A module is composed of one or more source files, and every source file is bound to a module.

Modules export their functions and types (structs).

!> Stark modules are not libraries! In native compilation a library is a machine compiled piece of code (static or dynamic),as Stark modules are compiled as bitcode in order to stay portable. A module is turned into machine code only when linked during binary compilation.

## Declaration

A source file is declared as belonging to a module by using the ``module`` keyword. It must be declared as the first statement of a source file:

```stark
// myModule.st
// A module named "myModule" containing an "add" function
module myModule

func add(a: int, b: int) => int {
  return a + b
}
```

When no module is declared for a source file, it is bound to the special module ``main``, the module containing the ``main`` function for executables.

Module declarations are not supported by the interpretrer: the interpreter can use modules but not define them.

## Usage

To use a module from another module, use the keyword ``import``. Once imported, types (structs) and functions from the other module are accessible to the target module using the imported module name as prefix:

```stark
// main.st
// Main program

import myModule

func main() {
  // functions (and types) imported from an external module must be prefixed by their module name.
  println(myModule.add(1, 2) as string)
}
```

## Compilation

Refer to the [Compiler](compiler.md) section form module compilation.