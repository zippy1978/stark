#include <cstdio>
#include <string.h>

#include "Runtime.h"

/**
 * IO primitive functions for runtime.
 */

extern "C" void stark_runtime_pub_print(stark::string_t *s)
{
    char out[s->len + 1];
    strcpy(out, s->data);
    out[s->len] = '\0';
    printf("%s", out);
}

extern "C" void stark_runtime_pub_println(stark::string_t *s)
{
    char out[s->len + 1];
    strcpy(out, s->data);
    out[s->len] = '\0';
    printf("%s\n", out);
}

extern "C" void stark_runtime_pub_printflush()
{
    fflush(stdout);
}

extern "C" stark::any_t stark_runtime_pub_stdout()
{
    return stdout;
}

extern "C" stark::any_t stark_runtime_pub_stdin()
{
    return stdin;
}

extern "C" stark::any_t stark_runtime_pub_stderr()
{
    return stderr;
}