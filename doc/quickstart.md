# Getting started

In this section, we are going to install Stark, write a first "Hello World" program, and run it using the Stark interpreter.

## Installation

!> At the moment, Stark is still in its early developpment stage, no binary package is available.

!> Build script is only compatible with macOS at the moment !

### Install dependencies

```bash
brew install llvm
brew install flex
brew install bison
```

### Clone the sources

```bash
$ git clone https://github.com/zippy1978/stark.git
```

### Build

From the project directory:

```bash
$ make
```

This will build the Stark binaries to the */bin* directory of the project directory and run all tests.

Once it is finished, here are the relevant binaries you will get:

- **stark** is the interpreter
- **starkc** is the compiler
- **libstark.so** is the runtime shared library
- **libstark.a** is the runtime static library

## A first program: "Hello World"

Create a *hello.st* file somewhere on your file system, open it and write:

```stark
println("Hello World")
```

Then save the file.

That's it, you wrote your first Stark program !

What the program is doing is pretty simple to understand : it uses the println function with a string parameter to output a message to the standard output.

You can now run it like this to see the result:

```bash
$ stark hello.st
Hello world
```

?> In Stark end of line do not require a *;*: each new line is a new instruction.

?> Note that no import statement is required to use println: this is because this function is part of the Stark runtime.

?> You can also note that no main function is required: when using the Stark interpreter, there is no need to add one.

