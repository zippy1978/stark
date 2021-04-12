#ifndef RUNTIME_RUNTIME_H
#define RUNTIME_RUNTIME_H

#include <string>

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

    class Runtime
    {
    public:
        /* Returns runtime declarations available to all source files */
        static std::string getDeclarations()
        {
            return "extern stark_runtime_priv_mm_init(): void\n"
                   "extern stark_runtime_priv_mm_alloc(size: int): any\n"

                   // Conversion
                   "extern stark_runtime_priv_conv_int_string(i: int): string\n"
                   "extern stark_runtime_priv_conv_int_double(i: int): double\n"
                   "extern stark_runtime_priv_conv_double_string(d: double): string\n"
                   "extern stark_runtime_priv_conv_bool_string(b: bool): string\n"
                   "extern stark_runtime_priv_conv_bool_int(b: bool): int\n"
                   "extern stark_runtime_priv_conv_bool_double(b: bool): double\n"
                   "extern stark_runtime_priv_conv_string_int(s: string): int\n"
                   "extern stark_runtime_priv_conv_string_double(s: string): double\n"
                   "extern stark_runtime_priv_conv_string_bool(s: string): bool\n"

                   "extern stark_runtime_pub_toCString(s: string): any\n"
                   "extern stark_runtime_pub_fromCString(s: any): string\n"
                   "extern stark_runtime_pub_toIntPointer(i: int): any\n"

                   "extern stark_runtime_priv_extract_args(argc: int, argv: any): any\n"

                   // IO
                   "extern stark_runtime_pub_stdout(): any\n"
                   "extern stark_runtime_pub_stdin(): any\n"
                   "extern stark_runtime_pub_stderr(): any\n"
                   "extern stark_runtime_pub_println(s: string)\n"
                   "extern stark_runtime_pub_printflush()\n"
                   "extern stark_runtime_pub_print(s: string)\n";
        }

        /* Returns runtime declarations available for testing */
        static std::string getTestDeclarations()
        {
            return "extern assertIntEquals(actual: int, expected: int)\n"
                   "extern assertStringEquals(actual: string, expected: string)\n"
                   "extern assertDoubleEquals(actual: double, expected: double)\n"
                   "extern assertTrue(actual: bool): void\n"
                   "extern assertNull(actual: any): void\n"
                   "extern failure(): void\n";
        
        }
    };

} // namespace stark

#endif
