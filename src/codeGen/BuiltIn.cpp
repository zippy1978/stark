#include <cstdio>
#include <time.h>
#include <iostream>

/**
 * Set of built-in functions that can be used from the JIT.
 * Note: cannot be used from a binary, unless linked.
 */

/* Print functions */

extern "C"
void printi(long long val) {
    printf("%lld\n", val);
}

extern "C"
void printd(double val) {
    printf("%f\n", val);
}

extern "C"
void print(const char* val) {
    printf("%s\n", val);
}

/* Test functions */

extern "C"
void assertIntEquals(long long actual, long long expected) {
    if (actual != expected) {
        printf("Assert failure : actual value %lld is different from expected %lld\n", actual, expected);
        exit(1);
    }
}

extern "C"
void assertDoubleEquals(double actual, double expected) {
    if (actual != expected) {
        printf("Assert failure : actual value %f is different from expected %f\n", actual, expected);
        exit(1);
    }
}

extern "C"
void assertTrue(bool actual) {
    if (!actual) {
        printf("Assert failure : not true\n");
        exit(1);
    }
}

extern "C"
void assertFalse(bool actual) {
    if (actual) {
        printf("Assert failure : not false\n");
        exit(1);
    }
}

extern "C"
void failure() {
    printf("Failure : should not be called\n");
    exit(1);
}

/* Time functions */

extern "C"
long long now() {
    return time(0);
}