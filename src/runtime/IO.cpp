#include <cstdio>
#include <string.h>

#include "Runtime.h"

/**
 * IO primitive functions for runtime.
 */

extern "C" void print(stark::string_t s) {
	char out[s.len + 1];
    strcpy(out,  s.data);
    out[s.len] = '\0';
    printf("%s", out);
}

extern "C" void println(stark::string_t s) {
	char out[s.len + 1];
    strcpy(out,  s.data);
    out[s.len] = '\0';
    printf("%s\n", out);
}