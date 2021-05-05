# Interpreter

The Stark interpreter is invoked using the ``stark`` command.

It is used to run Stark code as a script file (direct source execution).

?> Although it is named 'interpreter', the ``stark`` command is actually a JIT (Just In Time) compiler that compiles the provided source file before running it.

## Usage

stark [``options``] ``file`` [``arguments``]

``stark``command require only a file and extra arguments required to run the code.

```bash
# Run hello.st
$ stark hello.st
# Run hello.st with an argument
$ stark hello.st John
# Input code can also be piped
$ echo "println(\"Hello\")" | stark
```

Other options exist for a more advanced usage:

| Option        | Description                                                                                                                                     |
| ------------- |------------------------------------------------------------------------------------------------------------------------------------------------ |
| -d            | Enable debug mode (for the compiler itself).                                                                                                    |
| -v            | Print version information.                                                                                                                      |
| -h            | Print help.                                                                                                                                     |
| -m            | Module search path: paths separated with colons (in addition to paths defined by STARK_MODULE_PATH environment variable).                       |

## Reading arguments

Unlike compiled Star executables, interpreter code does not require a ``main``entry function: insctructions can be written at the root of the file:

```stark
println("Hello")
println("1 + 2 is " + (1 + 2) as string)
```

Arguments are available from the `àrgs`` variable of type ``string[]``:

```stark
if (args.len < 2) {
    println("missing parameter: program is expecting a name as parameter")
    return 1
} else {
    println("Hello " + args[1])
    return 0
}
```