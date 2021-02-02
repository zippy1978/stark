#include "CompilerModuleMapper.h"

namespace stark
{
    std::map<std::string, std::vector<std::string>> CompilerModuleMapper::map(std::vector<std::string> sourceFilenames)
    {
        std::map<std::string, std::vector<std::string>> result;

        // TODO : basic implementation
        // Innthe future : parse eache file to determine their module

        result["main"] = sourceFilenames;

        return result;
    }

} // namespace stark