# Modules

Modules are Stark code units.

A module is composed of one or more source files, and every source file is bound to a module.

Modules export their functions and types (structs).

## Declaration

A source file is declared as belonging to a module by using the **module** keyword. It must be declared as the first statement of a source file:

```stark
// myModule.st
// A module named "myModule" containing an "add" function
module myModule

func add(a: int, b: int): int {
  return a + b
}
```

When no module is declared for a source file, it is bound to the special module **main**, the module containing the **main** function for executables.

Module declarations are not supported by the interpretrer: the interpreter can use modules but not define them.

## Usage

To use a module from another module, use the keyword **import**:

```stark
// main.st
// Main program

import myModule

func main(): int {
  // functions (and types) imported from an external module must be prefixed by their module name.
  println(myModule.add(1, 2) as string)
  return 0
}
```

## Compilation

In order to compile a module, the **starkc** compiler command is used:

```bash
# Builds the module "myModule" into the "modules" directory
$ starkc -o modules myModule.st
```

After a successfull build, the compiler outputs the module into a directory named after the module. This directory contains 2 files : the module bitcode file (.bc) dans the module declaration file (.sth - Stark header)

```bash
$ ls modules/myModule
myModule.bc  myModule.sth

```
!> The compiler can build multiple modules in a single command, but cannot build the main (program) module with other modules at the same time.

```bash
# First build the module
$ starkc -o modules myModule.st
# Then build the program (and the compiler will link the moule)
$ starkc -m modules -o main main.bc
```

When building (or running) a program that uses modules, the compiler or the interpreter must know how to resolve those modules, in order to link them.

To do so, they must be provided with module search paths.

Module search paths can be set using the STARK_MODULE_PATH environment variable:

```bash
# Multiple paths are separated with ':'
$ export STARK_MODULE_PATH=/usr/lib/stark/modules:/my/modules
$ starkc -o main main.bc
```

Or with the **-m** option of the compiler and interpreter commands:

```bash
$ starkc -m /usr/lib/stark/modules:/my/modules -o main main.bc
```

Note, that both can be used at the same time.
