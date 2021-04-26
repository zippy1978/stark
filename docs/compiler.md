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

Cross compilation is the ability to compile binary code for a target machine which is different from the host machine.

Stark compiler is able to cross compile, and to do it, it needs:
- the specification of the target machine
- the appropriate cross linker
- the appropriate runtime

### Specify the target machine

Stark compiler is able to cross compile by specifying the target machine with the ``-t`` option.

This option expects target to be defined like this:

```triple```:```cpu```:```features```

The ```triple```also known as "target triple" is a format used by LLVM / Clang (and many other languages) to specify a target architecture, with the following format:

```arch``` ```sub```-```vendor```-```sys```-```abi```, where:

- ```arch```: x86_64, i386, arm, thumb, mips, etc.
- ```sub```: for ex. on ARM: v5, v6m, v7a, v7m, etc.
- ```vendor```: pc, apple, nvidia, ibm, etc.
- ```sys```: none, linux, win32, darwin, cuda, etc.
- ```abi```: eabi, gnu, android, macho, elf, etc.

The ```cpu```is used to define a specific cpu (like x86-64, swift, cortex-a15, ...). If not defined, ```generic```value is used. 

The ```features```is a comma separated list of target architecture specific features to enable (with a ```+``` prefix) or to disable (with a ```-``` prefix)

Here is an example:

```bash
# Cross compile for a generic arm target 
# with the vfp2 feature enabled (vector floating point v2 instructions)
$ starkc -t arm-unknown-linux-gnueabihf::+vfp2 -o hello hello.st
```

?> Note that ```cpu```and ```features``` part of the target can be omitted. In this case they can be left blank like this: ```armv6k-linux-gnueabi::```

If you try to cross compile with the example above, you should get a linker error that looks like:

```bash
linker:0:0 error: ld: warning: ignoring file hello.o, building for macOS-x86_64 but attempting to link with file built for unknown-unsupported file format ( 0x7F 0x45 0x4C 0x46 0x01 0x01 0x01 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 )
Undefined symbols for architecture x86_64:
  "_main", referenced from:
     implicit entry/start for main executable
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

This is because Stark compiler uses the default system linker to link the generated binary. But of course, this fails when the generated object code does not match the host system architecture (in the message above: the linker is expecting a macOS-x86_64 object file).

### Use the appropriate cross linker

To make the linking work, a cross linker must be used.

Getting the right cross linker depends on the target selected, it also depends on the host platform.

To get arm cross compilation tools on Linux (Ubuntu) you can install:

```bash
$ sudo apt-get install gcc-arm-linux-gnueabihf
```

On macOS with brew you can install cross compilation tools with:

```bash
$ brew tap SergioBenitez/osxct
# Install arm cross compiler / linker
# This may take a few minutes as tools are built from sources
$ brew install FiloSottile/musl-cross/musl-cross --without-x86_64 --with-arm-hf
```

Once appropriate tools are installed, the linker configuration can be passed to ``starkc`` using the ``-l``option.

``-l`` option expects linker options as:

``linker``:``linker flags``

If you consider compiling for an arm Linux target (such as a Raspberry Pi computer), from a Linux host, you can use (tested on Ubuntu):

```bash
$ starkc -t arm-unknown-linux-gnueabihf::+vfp2 -l "arm-linux-gnueabihf-gcc:-lpthread -lrt" -o hello hello.st
```

On macOS, use:

```bash
# On macOS it is recommanded to cross compile using a musl compiler / linker (a statically linked libc implemntation) 
$ starkc -t arm-unknown-linux-musleabihf::+vfp2 -l "arm-linux-musleabihf-gcc:-static -lpthread -lrt" -o hello hello.st
```

?> When linker is defined manually, ``pthrad``and ``rt``libs must be linked explicitly using linker flags. This is because, those libs are required by the Stark runtime.

If you try to run example commands above, you will notie once again that it still does not work, and you will get an error message like this one:

```bash
linker:0:0 error: /usr/local/Cellar/musl-cross/0.9.9_1/libexec/bin/../lib/gcc/arm-linux-musleabihf/9.2.0/../../../../arm-linux-musleabihf/bin/ld: hello.o: in function `main':
main:(.text+0x4): undefined reference to `stark_runtime_priv_mm_init'
/usr/local/Cellar/musl-cross/0.9.9_1/libexec/bin/../lib/gcc/arm-linux-musleabihf/9.2.0/../../../../arm-linux-musleabihf/bin/ld: main:(.text+0x18): undefined reference to `stark_runtime_priv_mm_alloc'
/usr/local/Cellar/musl-cross/0.9.9_1/libexec/bin/../lib/gcc/arm-linux-musleabihf/9.2.0/../../../../arm-linux-musleabihf/bin/ld: main:(.text+0x4c): undefined reference to `stark_runtime_priv_mm_alloc'
/usr/local/Cellar/musl-cross/0.9.9_1/libexec/bin/../lib/gcc/arm-linux-musleabihf/9.2.0/../../../../arm-linux-musleabihf/bin/ld: main:(.text+0x5c): undefined reference to `stark_runtime_pub_println'
collect2: error: ld returned 1 exit status
```

This is happing because, we are missing the final step in the cross compilation process: providing the right Stark runtime to the compiler.

### Link with the appropriate runtime

In order to run properly a Stark program must be linked with a runtime.

The runtime is a native library that provide lo livel mechanism to make Stark program work. For example, the Garbage Collector is part of the runtime.

As other native libraries, the runtime must be compiled for the appropriate target to support cross compilation.

By default, the ``starkc``command uses the runtime for the host machine, but when cross compiling, an approriate runtime must be explicitly provided using the ``-r``option.

Pre-compiled versions of the Stark runtime are available in the release section of the [Stark Github repository](https://github.com/zippy1978/stark/releases).

Here is the final (working) cross compilation command.

On Linux (Ubuntu):

```bash
# Donwload and unzip runtimes
$ wget https://github.com/zippy1978/stark/releases/download/0.0.1-SNAPSHOT/Stark-Runtimes-0.0.1-SNAPSHOT.zip
$ unzip Stark-Runtimes-0.0.1-SNAPSHOT.zip
# Cross compile for arm target
$ starkc -t arm-unknown-linux-gnueabihf::+vfp2 -r arm-unknown-linux-gnueabihf/libstark.a-l "arm-linux-gnueabihf-gcc:-lpthread -lrt" -o hello hello.st
```

On macOS:

```bash
# Donwload and unzip runtimes
$ wget https://github.com/zippy1978/stark/releases/download/0.0.1-SNAPSHOT/Stark-Runtimes-0.0.1-SNAPSHOT.zip
$ unzip Stark-Runtimes-0.0.1-SNAPSHOT.zip
# Cross compile for arm target
$ starkc -t arm-unknown-linux-musleabihf::+vfp2 -r arm-unknown-linux-musleabihf/libstark.a -l "arm-linux-musleabihf-gcc:-static -lpthread -lrt" -o hello hello.st
```

Once compiled the ``hello`` binary will not run on the host machine

```bash
$ ./hello
zsh: exec format error: ./hello
# Check hello format with the 'file' command
$ file hello
hello: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), statically linked, with debug_info, not stripped
```

?> Add ``-s``to the linker flags to strip debug symbols while linking.
