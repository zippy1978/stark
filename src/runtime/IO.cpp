#include <cstdio>

/**
 * Set of built-in functions that can be used from the JIT.
 * Note: cannot be used from a binary, unless linked.
 */

/* Print functions */

extern "C" void printi(long long val)
{
    printf("%lld\n", val);
}

extern "C" void printd(double val)
{
    printf("%f\n", val);
}

extern "C" void print(const char *val)
{
    printf("%s\n", val);
}