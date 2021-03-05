#include <string>
#include <cassert>
#include <vector>

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

    std::vector<std::string> split(const std::string &s, char delimiter);

    std::string ltrim(std::string s);

    std::string rtrim(std::string s);

    std::string trim(std::string s);

} // namespace stark