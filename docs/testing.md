# Testing

Like other languages, the Stark language provide tools to peform code testing.

Testing tools are composed of:
- a test runner command
- a set of assert functions

## Writing tests

Here is the basic ``math``module under test:

```stark
// math.st
module math

func add(a: int, b: int): int {
    return a + b
}

func sub(a: int, b: int): int {
    return a - b
}
```

And here is the test code:

```stark
// math.test.st
import math

func testAdd() {
    assertIntEquals(math.add(1, 2), 3)
}

func testSub() {
    assertIntEquals(math.sub(1, 2), -1)
}
```

Nothing complicated here: test functions must start with ``test*`` by default. Each of them will be picked by the test runner when running tests.

## Available test functions

In the example above, funciton ``assertIntEquals`` is used. It is a built-in tes function available to any test files.

Here is the list of all built-in test functions:

```stark
assertIntEquals(actual: int, expected: int)
assertStringEquals(actual: string, expected: string)
assertDoubleEquals(actual: double, expected: double)
assertTrue(actual: bool)
assertNull(actual: any)
failure()
```

## Running tests

Tests can be run using the ``starktest`` command, the Stark test runner.

Here is how to run the above test example:

```bash
# First build the math module
$ mkdir modules
$ starkc -o modules math.st
# Run tests
$ starktest -m modules *.test.st
Running tests from math.test.st
testAdd ...  passed (91 ms)
testSub ...  passed (25 ms)
2 test(s) run, passed: 2, failed: 0, time: 116 ms
```

## Runner usage

starktest [``options``] ``files...``

Options are:

| Option        | Description                                                                                                                                     |
| ------------- |------------------------------------------------------------------------------------------------------------------------------------------------ |
| -d            | Enable debug mode (for the compiler itself).                                                                                                    |
| -v            | Print version information.                                                                                                                      |
| -h            | Print help.                                                                                                                                     |
| -m            | Module search path: paths separated with colons (in addition to paths defined by STARK_MODULE_PATH environment variable).                       |
| -i            | Stark interpreter used to run tests. Default is 'stark'.                                                                                        |
| -p            | Test function prefix. Default is 'test'.                                                                                                        |
 