#include <iostream>
#include <stdarg.h>

#include "StringUtil.h"

#include "Logger.h"

namespace stark
{

    /* Logger */

    std::string Logger::buildMessage(std::string typeName, FileLocation location, std::string message)
    {
        if (location.column == 0 && location.line == 0 && filename.compare("unknown") == 0)
        {
            return stark::format("%s: %s", typeName.c_str(), message.c_str());
        }
        else
        {
            return stark::format("%s:%d:%d %s: %s", filename.c_str(), location.line, location.column, typeName.c_str(), message.c_str());
        }
    }

    void Logger::logError(std::string message)
    {
        FileLocation location;
        this->logError(location, message);
    }

    void Logger::logWarn(std::string message)
    {
        FileLocation location;
        this->logWarn(location, message);
    }

    void Logger::logDebug(std::string message)
    {
        FileLocation location;
        this->logDebug(location, message);
    }

    void Logger::logError(FileLocation location, std::string message)
    {
        std::cerr << buildMessage("error", location, message) << std::endl;
        exit(1);
    }

    void Logger::logWarn(FileLocation location, std::string message)
    {
        std::cerr << buildMessage("warning", location, message) << std::endl;
    }

    void Logger::logDebug(FileLocation location, std::string message)
    {
        if (this->debugEnabled)
        {
            std::cerr << buildMessage("debug", location, message) << std::endl;
        }
    }

} // namespace stark