#ifndef RUNTIME_RUNTIME_H
#define RUNTIME_RUNTIME_H

#include <string>

namespace stark
{
    using int_t = long long;
    using double_t = double;
    using any_t = void *;

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

    class Runtime
    {
    public:
        /* Returns runtime declarations available to all source files */
        static std::string getDeclarations()
        {
            return "extern stark_runtime_mm_init(): void\n"
                   "extern stark_runtime_mm_alloc(size: int): any\n"
                   "extern stark_runtime_conv_int_string(i: int): string\n"
                   "extern println(s: string): void\n"
                   "extern print(s: string): void\n";
        }
    };

} // namespace stark

#endif
