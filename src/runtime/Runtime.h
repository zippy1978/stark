

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

} // namespace stark
