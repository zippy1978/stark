#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Runtime.h"
#include "Memory.h"

extern "C" stark::string_t intToString(stark::int_t i)
{
    char str[30];
    sprintf(str, "%lld", i);

    stark::string_t result;
    result.len = strlen(str);
    // TODO : leak here ! will use GC when available
    result.data = (char *)stark_runtime_mm_alloc(sizeof(char) * result.len);
	strcpy(result.data, str);
    return result;
}