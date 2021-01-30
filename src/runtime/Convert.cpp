#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Runtime.h"
#include "Memory.h"

extern "C" stark::string_t stark_runtime_priv_conv_int_string(stark::int_t i)
{
    char str[30];
    sprintf(str, "%lld", i);

    stark::string_t result;
    result.len = strlen(str);
    result.data = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * result.len);
	strcpy(result.data, str);
    return result;
}

extern "C" stark::double_t stark_runtime_priv_conv_int_double(stark::int_t i)
{
    return (stark::double_t)i;
}

extern "C" stark::string_t stark_runtime_priv_conv_double_string(stark::double_t d)
{
    char str[30];
    sprintf(str, "%f", d);

    stark::string_t result;
    result.len = strlen(str);
    result.data = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * result.len);
	strcpy(result.data, str);
    return result;
}