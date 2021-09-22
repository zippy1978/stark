#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "RuntimeTypes.h"
#include "Memory.h"

extern "C" stark::array_t *stark_runtime_priv_concat_array(stark::array_t *ls, stark::array_t *rs, stark::int_t elementSize)
{
    stark::array_t *result = (stark::array_t *)stark_runtime_priv_mm_alloc(sizeof(stark::array_t));
    result->len = ls->len + rs->len;
    stark::any_t *elements = (stark::any_t *)stark_runtime_priv_mm_alloc(elementSize * result->len);
    memcpy(elements, ls->elements, ls->len * elementSize);
    memcpy(elements + ls->len, rs->elements, rs->len * elementSize);
    result->elements = elements;

    return result;
}