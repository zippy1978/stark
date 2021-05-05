#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "RuntimeTypes.h"
#include "Memory.h"

/**
 * Set of built-in functions to interact with C code.
 */

extern "C" stark::any_t stark_runtime_pub_toCString(stark::string_t *s)
{
    char *result = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * (s->len + 1));
    strcpy(result, s->data);
    return (stark::any_t)result;
}

extern "C" stark::string_t *stark_runtime_pub_fromCString(stark::any_t s)
{
    stark::string_t *result = (stark::string_t *)stark_runtime_priv_mm_alloc(sizeof(stark::string_t));
    result->len = strlen((char *)s);
    result->data = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * result->len);
    strcpy(result->data, (char *)s);
    return result;
}

extern "C" stark::any_t stark_runtime_pub_toIntPointer(stark::int_t i)
{
    stark::any_t *result = (stark::any_t *)stark_runtime_priv_mm_alloc(sizeof(stark::int_t));
    memcpy(result, &i, sizeof(stark::int_t));
    return result;
}