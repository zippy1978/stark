#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "RuntimeTypes.h"
#include "Memory.h"

/**
 * Set of built-in functions related to primary types manipulation.
 */

// int

extern "C" stark::string_t *stark_runtime_priv_conv_int_string(stark::int_t i)
{
    char str[30];
    sprintf(str, "%lld", i);

    stark::string_t *result = (stark::string_t *)stark_runtime_priv_mm_alloc(sizeof(stark::string_t));
    result->len = strlen(str);
    result->data = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * result->len + 1);
    strcpy(result->data, str);
    return result;
}

extern "C" stark::double_t stark_runtime_priv_conv_int_double(stark::int_t i)
{
    return (stark::double_t)i;
}

// double

extern "C" stark::string_t *stark_runtime_priv_conv_double_string(stark::double_t d)
{
    char str[30];
    sprintf(str, "%lf", d);

    stark::string_t *result = (stark::string_t *)stark_runtime_priv_mm_alloc(sizeof(stark::string_t));
    result->len = strlen(str);
    result->data = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * result->len + 1);
    strcpy(result->data, str);
    return result;
}

// bool

extern "C" stark::string_t *stark_runtime_priv_conv_bool_string(stark::bool_t b)
{
    char str[10];
    sprintf(str, b == 0 ? "false" : "true");

    stark::string_t *result = (stark::string_t *)stark_runtime_priv_mm_alloc(sizeof(stark::string_t));
    result->len = strlen(str);
    result->data = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * result->len + 1);
    strcpy(result->data, str);
    return result;
}

extern "C" stark::int_t stark_runtime_priv_conv_bool_int(stark::bool_t b)
{
    return (stark::int_t)b;
}

extern "C" stark::double_t stark_runtime_priv_conv_bool_double(stark::bool_t b)
{
    return (stark::double_t)b;
}