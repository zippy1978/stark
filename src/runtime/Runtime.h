#ifndef RUNTIME_RUNTIME_H
#define RUNTIME_RUNTIME_H

#include <string>

namespace stark
{
    using sint = long long;
    using sdouble = double;

    typedef struct
    {
        char *data;
        sint len;
    } string;

    typedef struct
    {
        void *elements;
        sint len;
    } array;

    class Runtime
    {
    public:
        static std::string getDeclarations() {
            return 
            "extern println(s: string): void\n"
            "extern print(s: string): void\n";
        }
    };

} // namespace stark

#endif
