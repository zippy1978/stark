#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "RuntimeTypes.h"
#include "Memory.h"

/**
 * Set of built-in functions related to string type manipulation.
 */

extern "C" stark::int_t stark_runtime_priv_conv_string_int(stark::string_t *s)
{
    char *ptr;
    return  strtoll(s->data, &ptr, 10);
}

extern "C" stark::double_t stark_runtime_priv_conv_string_double(stark::string_t *s)
{
    char *ptr;
    return strtod(s->data, &ptr);
}

extern "C" stark::bool_t stark_runtime_priv_conv_string_bool(stark::string_t *s)
{
    return (stark::bool_t)(strncmp(s->data, "true", s->len) == 0);
}

extern "C" stark::string_t *stark_runtime_priv_concat_string(stark::string_t *ls, stark::string_t *rs)
{
    char *dest = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * (ls->len + rs->len + 2));
    strncpy(dest, ls->data, ls->len);
    strncat(dest, rs->data, rs->len);

    stark::string_t *result = (stark::string_t *)stark_runtime_priv_mm_alloc(sizeof(stark::string_t));
    result->len = strlen((char *)dest);
    result->data = dest;
    return result;
}

extern "C" stark::bool_t stark_runtime_priv_eq_string(stark::string_t *ls, stark::string_t *rs)
{
    if (ls->len == rs->len) {
        return (stark::bool_t)(strncmp(ls->data, rs->data, ls->len) == 0);
    } else {
        return false;
    }
}

extern "C" stark::bool_t stark_runtime_priv_neq_string(stark::string_t *ls, stark::string_t *rs)
{
    if (ls->len == rs->len) {
        return (stark::bool_t)(strncmp(ls->data, rs->data, ls->len) != 0);
    } else {
        return true;
    }
    
    
}