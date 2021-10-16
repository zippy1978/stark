#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

#include "RuntimeTypes.h"
#include "Memory.h"

extern "C" stark::any_t stark_runtime_priv_extract_args(stark::int_t argc, stark::any_t argv)
{
    stark::array_t *args = (stark::array_t *)stark_runtime_priv_mm_alloc(sizeof(stark::array_t));
    args->len = argc;
    stark::string_t **elements = (stark::string_t **)stark_runtime_priv_mm_alloc(sizeof(stark::string_t *) * argc);
    for (int i = 0; i < argc; i++)
    {
        stark::string_t *s = (stark::string_t *)stark_runtime_priv_mm_alloc(sizeof(stark::string_t *));
        s->len = strlen(((char **)argv)[i]);
        s->data = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * s->len + 1);
        strcpy(s->data, ((char **)argv)[i]);
        elements[i] = s;
    }
    args->elements = elements;

    return args;
}

extern "C" stark::int_t stark_runtime_pub_time()
{
    struct timeval tv;

    gettimeofday(&tv, NULL);
    return (unsigned long long)(tv.tv_sec) * 1000 + (unsigned long long)(tv.tv_usec) / 1000;
}