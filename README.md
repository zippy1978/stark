# The Stark programming language

Welcome to the Stark programming language source code repository.

This repository contains everything to build:

- The **starkc** compiler command
- The **stark** interpreted command
- The language runtime (available as a static or shared library)

Stark currently runs on Linux and macOS.

## Getting started

### Toolchain

The project is written in C++ (C++14) and uses [CMake](https://cmake.org/) as build tool, and [conan](https://conan.io/) as package manager.

Eventhough conan is used to manage project dependencies, some of them still require to be installed aside, those are:

 - llvm 11+
 - flex 2.6+
 - bison 3.5+

For fast building the use of [ninja](https://ninja-build.org/) is recommended.

#### macOS setup

Here are the commands to install all the required tools above with [Homebrew](https://brew.sh/) on macOS:


```
brew install cmake
brew install conan
brew install llvm
brew install flex
brew install bison
brew ninja
```

#### Linux (Ubuntu) setup

On Linux (tested on Ubuntu), required tools can be installed with:

```
apt-get -y install llvm clang git cmake python python3-pip bison libfl-dev flex ninja-build

pip3 install conan
```

### Building

Once all the required tools are installed, use the following commands to generate the project (here with ninja build system):

```
# From the project root directory
# Create build directory
mkdir build && cd build
# Install conan dependencies
conan install ..
# Generate ninja project with cmake
cmake -GNinja ..
```

Then build the project

```
# From the project build directory
ninja
```

After a successfuly build, **stark** and **starkc** binaries will be available from *build/bin* directory, and runtime libraries from the *build/lib* directory.



### Testing

Run tests with:

```
# From the project build directory
ninja test
```

### Installing


Install with:

```
# From the project build directory
ninja install
```

Test installation with:

```
stark -v
Stark interpreter version 0.0.1
```

Uninstall with:

```
# From the project build directory
ninja uninstall
```

