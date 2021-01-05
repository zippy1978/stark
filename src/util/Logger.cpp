#include <iostream>
#include <stdarg.h>
#include "StringUtil.h"

#include "Logger.h"

namespace stark
{

    /* Logger */

    void Logger::logError(std::string message)
    {
        va_list args;
        std::string outputMessage = stark::format("ERROR: %s", message.c_str());
        std::cerr << outputMessage << std::endl;
        exit(1);
    }

    void Logger::logWarn(std::string message)
    {
        std::string outputMessage = stark::format("WARNING: %s", message.c_str());
        std::cerr << outputMessage << std::endl;
    }

    void Logger::logDebug(std::string message)
    {
        if (this->debugEnabled)
        {
            std::string outputMessage = stark::format("DEBUG: %s", message.c_str());
            std::cerr << outputMessage << std::endl;
        }
    }

} // namespace stark