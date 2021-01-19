#include <iostream>
#include <stdarg.h>
#include "StringUtil.h"

#include "Logger.h"

namespace stark
{

    /* Logger */

    std::string Logger::buildMessage(std::string typeName, LogPosition pos, std::string message)
    {
        return stark::format("%s:%d:%d %s: %s", filename != NULL ? filename->c_str() : "unknown", pos.line, pos.column, typeName.c_str(), message.c_str());
        
    }

    void Logger::logError(std::string message)
    {
        LogPosition pos;
        this->logError(pos, message);
    }

    void Logger::logWarn(std::string message)
    {
        LogPosition pos;
        this->logWarn(pos, message);
    }

    void Logger::logDebug(std::string message)
    {
        LogPosition pos;
        this->logDebug(pos, message);
    }

    void Logger::logError(LogPosition pos, std::string message)
    {
        std::cerr << buildMessage("error", pos, message) << std::endl;
        exit(1);
    }

    void Logger::logWarn(LogPosition pos, std::string message)
    {
        std::cerr << buildMessage("warning", pos, message) << std::endl;
    }

    void Logger::logDebug(LogPosition pos, std::string message)
    {
        if (this->debugEnabled)
        {
            std::cerr << buildMessage("debug", pos, message) << std::endl;
        }
    }

} // namespace stark