# Getting started

In this section, we are going to install Stark, write a first "Hello World" program, and run it using the Stark interpreter.

## Installation

!> At the moment, Stark is still in its early developpment stage, no binary package is available.


### Requirements

Stark currently runs on Linux and macOS.
In order to compile, some tools are required.

#### macOS setup

Here are the commands to install all the required tools above with [Homebrew](https://brew.sh/) on macOS:


```bash
$ brew install cmake
$ brew install conan
$ brew install llvm
$ brew install flex
$ brew install bison
$ brew ninja
```

#### Linux (Ubuntu) setup

On Linux (tested on Ubuntu), required tools can be installed with:

```bash
$ apt-get -y install llvm clang git cmake python python3-pip bison libfl-dev flex ninja-build
$ pip3 install conan
```

### Building

Once all the required tools are installed, use the following commands to generate the project (here with ninja build system):

```bash
# From the project root directory
# Create build directory
$ mkdir build && cd build
# Install conan dependencies
$ conan install ..
# Generate ninja project with cmake
$ cmake -GNinja ..
```

Then build the project

```bash
# From the project build directory
$ ninja
```

And install it to your system with:

```bash
# From the project build directory
$ ninja install
```

At anytime, Stark can be uninstalled with:

```bash
# From the project build directory
$ ninja uninstall
```

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

