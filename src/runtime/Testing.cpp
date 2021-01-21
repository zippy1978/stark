#include <cstdio>
#include <iostream>

#include "Runtime.h"

/**
 * Set of built-in functions that can be used from the JIT.
 * Note: cannot be used from a binary, unless linked.
 */

/* Test functions */

extern "C" void assertIntEquals(long long actual, long long expected)
{
    if (actual != expected)
    {
        printf("Assert failure : actual value %lld is different from expected %lld\n", actual, expected);
        exit(1);
    }
}

extern "C" void assertDoubleEquals(double actual, double expected)
{
    if (actual != expected)
    {
        printf("Assert failure : actual value %f is different from expected %f\n", actual, expected);
        exit(1);
    }
}
extern "C" void assertStringEquals(stark::string actual, stark::string expected)
{
    char actualCString[actual.len + 1];
    strcpy(actualCString, actual.data);

    char expectedCString[expected.len + 1];
    strcpy(expectedCString, expected.data);

    if (strcmp(actualCString, expectedCString) != 0)
    {
        printf("Assert failure : actual value '%s' is different from expected '%s'\n", actualCString, expectedCString);
        exit(1);
    }
}

extern "C" void assertTrue(bool actual)
{
    if (!actual)
    {
        printf("Assert failure : not true\n");
        exit(1);
    }
}

extern "C" void assertFalse(bool actual)
{
    if (actual)
    {
        printf("Assert failure : not false\n");
        exit(1);
    }
}

extern "C" void failure()
{
    printf("Failure : should not be called\n");
    exit(1);
}