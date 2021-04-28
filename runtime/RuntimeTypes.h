#ifndef RUNTIME_RUNTIMETYPES_H
#define RUNTIME_RUNTIMETYPES_H

#include <string>

/**
 * Defines Stark types for runtime usage.
 */

namespace stark
{
    using int_t = long long;
    using double_t = double;
    using any_t = void *;
    using bool_t = unsigned char;

    typedef struct
    {
        char *data;
        int_t len;
    } string_t;

    typedef struct
    {
        void *elements;
        int_t len;
    } array_t;
}

#endif