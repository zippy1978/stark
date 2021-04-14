# The Stark programming language

Welcome to the Stark programming language documentation !

Before diving into the technical documentation, consider reading the purpose of Stark and its main characteristics.

## Why another language ?

Why another language ? You may ask... And this is a good question actually !

There are already a lot of pretty good languages around, so why another one ? The short answer is: to fill gaps. The gap between low and high level languages, the gap between small hardware and heavy duty servers, the gap between interpreted and compiled languages.

To do so, Stark is designed with the following concepts in mind : **portability**, **performance**, **simplicity**.

### Portability

Portability means being able to run the exact same code on many different hardware, no matter what their power is.

To do so, Stark tries to rely as less as possible on hardware specific features by using LLVM to generate code. When compiling, Stark outputs .bc files (bitcode file) that will be translated to architecture specific binaries only when needed. This is a principle we call the "late late metal": compiling to machine code as late as possible.

Also, the Stark runtime is kept as minimal as possible, and only relies on widely supported libc (standard C library) features.

### Performance

Performance means running fast, but also not wasting ressources. Instructions do only what they are meant to do.

Also, Stark runtime tries to keep the smallest footprint as possible, to save ressources (memory, and storage).

### Simplicity

Simplicity means, easy to learn but also keeping things simple : not 100 ways to do the same thing. In the end object code is just a binary with entry points. So let's keep the right balance between that and a feature overloaded language.

## Main features

Writing a new programming language is a long journey (that probably never ends !), but like every journey, it has a start!

Here are the main features of Stark at the moment:
- Support for primary types (int, double, bool), builtin complex types (string, arrays) and custom complex type (using structs)
- Managed memory (garbage collector)
- Code modules
- Cross-compilation (made very easy !)
- AOT (Ahead Of Time) compilation
- JIT (Just In Time) interpreter
- Test runner
- C code interfacing
