#include <string>

namespace stark
{

    template <typename... Args>
    std::string format(std::string format, Args... args)
    {
        int length = std::snprintf(nullptr, 0, format.c_str(), args...);
        assert(length >= 0);

        char *buf = new char[length + 1];
        std::snprintf(buf, length + 1, format.c_str(), args...);

        std::string str(buf);
        delete[] buf;
        return str;
    }

} // namespace stark