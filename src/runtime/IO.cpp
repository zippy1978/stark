#include <cstdio>
#include <string.h>

#include "Runtime.h"

/**
 * Set of built-in functions that can be used from the JIT.
 * Note: cannot be used from a binary, unless linked.
 */

/* Print functions */

extern "C" void printi(stark::sint val)
{
    printf("%lld\n", val);
}

extern "C" void printd(stark::sdouble val)
{
    printf("%f\n", val);
}

extern "C" void print(stark::string s) {
	char out[s.len + 1];
    strcpy(out,  s.data);
    out[s.len] = '\0';
    printf("%s", out);
}

extern "C" void println(stark::string s) {
	char out[s.len + 1];
    strcpy(out,  s.data);
    out[s.len] = '\0';
    printf("%s\n", out);
}