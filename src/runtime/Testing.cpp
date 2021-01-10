#include <cstdio>
#include <iostream>

/**
 * Set of built-in functions that can be used from the JIT.
 * Note: cannot be used from a binary, unless linked.
 */

typedef struct intArray {
    long long* elements;
    long long len;
} intArray;

extern "C" intArray createIntArray()
{
    intArray arr;
    long long* innerArray = (long long *)malloc(3 * sizeof(long long));
    innerArray[0] = 1;
    innerArray[1] = 2;
    innerArray[2] = 3;
    arr.elements = innerArray;
    arr.len = 3;
    return arr;
}

extern "C" void printIntArray(intArray arr)
{
    printf("content = %lld, %lld, %lld . size = %lld\n", arr.elements[0], arr.elements[1], arr.elements[2], arr.len);
}

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