#include <cstdio>
#include <iostream>

#include "Runtime.h"

/**
 * Set of built-in functions that can be used from the JIT.
 * Note: cannot be used from a binary, unless linked.
 */

typedef struct intArray {
    long long* elements;
    long long len;
} intArray;

typedef struct trooper {
    stark::string name;
    long long serial;
} trooper;

typedef struct trooperArray {
    trooper* elements;
    long long len;
} trooperArray;

extern "C" trooperArray createTrooperArray()
{
    trooperArray arr;
    trooper* innerArray = (trooper*)malloc(2 * sizeof(trooper));

    trooper t1;
    stark::string t1_name;
    t1_name.data = (char*)malloc(3 * sizeof(char));
    t1_name.data[0] = 'g';
    t1_name.data[1] = 'g';
    t1_name.data[2] = 'r';
    t1_name.len = 3;
    t1.name = t1_name;
    t1.serial = 1;

    trooper t2;
    stark::string t2_name;
    t2_name.data = (char*)malloc(2 * sizeof(char));
    t2_name.data[0] = 'f';
    t2_name.data[1] = 'f';
    t2_name.data[2] = 'r';
    t2_name.len = 3;
    t2.name = t2_name;
    t2.serial = 2;

    innerArray[0] = t1;
    innerArray[1] = t2;
    arr.elements = innerArray;
    arr.len = 2;
    return arr;
}

extern "C" void printTrooperArray(trooperArray arr)
{
    char out1[arr.elements[0].name.len + 1];
    strcpy(out1,  arr.elements[0].name.data);
    out1[arr.elements[0].name.len] = '\0';

    char out2[arr.elements[1].name.len + 1];
    strcpy(out2,  arr.elements[1].name.data);
    out2[arr.elements[1].name.len] = '\0';

    printf("name = %s, serial = %lld\n", out1, arr.elements[0].serial);
    printf("name = %s, serial = %lld\n", out2, arr.elements[1].serial);
    printf("size = %lld\n", arr.len);
    //printf("content = %lld, %lld, %lld . size = %lld\n", arr.elements[0], arr.elements[1], arr.elements[2], arr.len);
}

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