# Compiler

The Stark compiler is invoked using the ``starkc`` command.

It is used to build native binaries, or Stark modules.

## Usage

starkc [``options``] ``files...``

``starkc``command require a file, or list of files to compile. Usage of wildcard is also suported thanks to the shell. Also ``-o`` (output file) option is mandatory for compilation.

```bash
# Compile hello.st to hello binary
$ starkc -o hello hello.st
# Compile hello.st and goodby.st to helloGoodbye binary
$ starkc -o helloGoodbye hello.st goodbye.st
# Compile source files of the src directory to all binary
$ starkc -o all src/*.st
```

Other options exist for a more advanced usage:

| Option        | Description                                                                                                                                     |
| ------------- |------------------------------------------------------------------------------------------------------------------------------------------------ |
| -o            | Output file name or directory name (for modules).                                                                                               |
| -d            | Enable debug mode (for the compiler itself).                                                                                                    |
| -v            | Print version information.                                                                                                                      |
| -h            | Print help.                                                                                                                                     |
| -r            | Static Stark runtime (libstark.a) file name to use for compilation. If not provided, used the one defined by STARK_RUNTIME environment variable.|
| -m            | Module search path: paths separated with colons (in addition to paths defined by STARK_MODULE_PATH environment variable).                       |
| -t            | Cross compilation target. Expected format is triple:cpu:features. If not provided, uses host target.                                            |
| -l            | Linker settings. Expected format is linker_command:linker_flags. If not provided, uses cc. Use 'none' value to disable linking.                 |

``-r``, ``-t``and ``-l`` options are mostly used from cross compilation, as explained later in this section.

## Binary compilation

Binary compilation involves turning source code to an executable binary file.

This process has 2 steps:
1. Compiling the source code to a ``.o`` object file
2. Linking the object file with the Stark runtime (an eventually other system libraries)

As explained in the [Getting started](quickstart.md) already. This is done like this:

```bash
# Compile hello.st to hello binary
$ starkc -o hello hello.st
# Run the binary
$ ./hello
Hello world
```

### Disable linking

In some cases, it may be useful to disable the linking phase and only get the compiled object file to link it later with the tool of your choice.

To disable linking, pass ``none``to the linker switch:

```bash
$ starkc -l none -o hello hello.st
```

### Linking with native libraries

Thanks to extern functions, Stark can call plain C functions. 

However if those functions are part of an external static or dynamic library, they must be linked explicitly.

```bash
# Link curl library
$ starkc -l "cc:-lcurl" -o hello hello.st
```

## Module compilation

Contrary of a binary, a Stark module does not output a single file but a directory.

Each module directory contains at least 2 files:
- a ``.sth`` file, which is the module declaration header (a generated Stark source file), used when linking the module at compilation time.
- a ``.bc``file, which is the bitcode compiled module code.

Stark tries to follow our "late late metal" principle: machine compilation takes place as late as possible to keep code portable.

Compiling a module is pretty much the same as compiling a binary, except that the output ``-o`` is a directory (must be created before building) where the module will be built:

```bash
# Builds the module "myModule" into the "modules" directory
$ starkc -o modules myModule.st
```

After a successfull build, the compiler outputs the module into a directory named after the module.

```bash
$ ls modules/myModule
myModule.bc  myModule.sth

```
!> The compiler can build multiple modules in a single command, but cannot build the main (program) module with other modules at the same time.

```bash
# First build the module
$ starkc -o modules myModule.st
# Then build the program (and the compiler will link the module)
$ starkc -m modules -o main main.bc
```

## Linking modules

When building (or running) a program that uses modules, the compiler or the interpreter must know how to resolve those modules, in order to link them.

To do so, they must be provided with module search paths.

Module search paths can be set using the ``STARK_MODULE_PATH`` environment variable:

```bash
# Multiple paths are separated with ':'
$ export STARK_MODULE_PATH=/usr/lib/stark/modules:/my/modules
$ starkc -o main main.bc
```

Or with the ``-m`` option of the compiler and interpreter commands:

```bash
$ starkc -m /usr/lib/stark/modules:/my/modules -o main main.bc
```

Note, that both can be used at the same time.


## Cross compilation

TBC