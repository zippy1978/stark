#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Runtime.h"
#include "Memory.h"

// int

extern "C" stark::string_t* stark_runtime_priv_conv_int_string(stark::int_t i)
{
    char str[30];
    sprintf(str, "%lld", i);

    stark::string_t *result = (stark::string_t *)stark_runtime_priv_mm_alloc(sizeof(stark::string_t));
    result->len = strlen(str);
    result->data = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * result->len);
    strcpy(result->data, str);
    return result;
}

extern "C" stark::double_t stark_runtime_priv_conv_int_double(stark::int_t i)
{
    return (stark::double_t)i;
}

// double

extern "C" stark::string_t* stark_runtime_priv_conv_double_string(stark::double_t d)
{
    char str[30];
    sprintf(str, "%lf", d);

    stark::string_t *result = (stark::string_t *)stark_runtime_priv_mm_alloc(sizeof(stark::string_t));
    result->len = strlen(str);
    result->data = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * result->len);
    strcpy(result->data, str);
    return result;
}

// bool

extern "C" stark::string_t* stark_runtime_priv_conv_bool_string(stark::bool_t b)
{
    char str[10];
    sprintf(str, b == 0 ? "false" : "true");

    stark::string_t *result = (stark::string_t *)stark_runtime_priv_mm_alloc(sizeof(stark::string_t));
    result->len = strlen(str);
    result->data = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * result->len);
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

// string

extern "C" stark::int_t stark_runtime_priv_conv_string_int(stark::string_t* s)
{
    char *ptr;
    return strtoll(s->data, &ptr, 10);
}

extern "C" stark::double_t stark_runtime_priv_conv_string_double(stark::string_t* s)
{
    char *ptr;
    return strtod(s->data, &ptr);
}

extern "C" stark::bool_t stark_runtime_priv_conv_string_bool(stark::string_t* s)
{
    return (stark::bool_t) (strcmp( s->data, "true" ) == 0);
}

// Public functions

extern "C" stark::any_t stark_runtime_pub_toCString(stark::string_t *s)
{
    char* result = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * (s->len + 1));
    strcpy(result, s->data);
    return (stark::any_t)result;
}

extern "C" stark::string_t* stark_runtime_pub_fromCString(stark::any_t s)
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