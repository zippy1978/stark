#include <cstdio>
#include <iostream>
#include <cstring>

#include "RuntimeTypes.h"

/**
 * Set of built-in functions that can be used from the JIT.
 * Note: cannot be used from a binary, unless linked.
 */

extern "C" void assertIntEquals(stark::int_t actual, stark::int_t expected)
{
    if (actual != expected)
    {
        fprintf(stderr, "Assert failure : actual value %lld is different from expected %lld\n", actual, expected);
        exit(1);
    }
}

extern "C" void assertDoubleEquals(stark::double_t actual, stark::double_t expected)
{
    if (actual != expected)
    {
        fprintf(stderr, "Assert failure : actual value %f is different from expected %f\n", actual, expected);
        exit(1);
    }
}
extern "C" void assertStringEquals(stark::string_t *actual, stark::string_t *expected)
{
    char actualCString[actual->len + 1];
    strcpy(actualCString, actual->data);

    char expectedCString[expected->len + 1];
    strcpy(expectedCString, expected->data);

    if (strcmp(actualCString, expectedCString) != 0)
    {
        fprintf(stderr, "Assert failure : actual value '%s' is different from expected '%s'\n", actualCString, expectedCString);
        exit(1);
    }
}

extern "C" void assertTrue(bool actual)
{
    if (!actual)
    {
        fprintf(stderr, "Assert failure : not true\n");
        exit(1);
    }
}

extern "C" void assertFalse(bool actual)
{
    if (actual)
    {
        fprintf(stderr, "Assert failure : not false\n");
        exit(1);
    }
}

extern "C" void assertNull(stark::any_t actual)
{
    if (actual != nullptr)
    {
        fprintf(stderr, "Assert failure : not null\n");
        exit(1);
    }
}

extern "C" void failure()
{
    fprintf(stderr, "Failure : should not be called\n");
    exit(1);
}