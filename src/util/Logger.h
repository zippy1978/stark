#ifndef UTIL_LOGGER_H
#define UTIL_LOGGER_H

#include <string>

#include "FileLocation.h"

namespace stark
{

  /**
 * Logger
 */
  class Logger
  {
    std::string filename = "unknown";

  private:
    std::string buildMessage(std::string typeName, FileLocation location, std::string message);

  public:
    bool debugEnabled;
    Logger() { debugEnabled = false; }
    virtual ~Logger() {}
    void logError(std::string message);
    void logWarn(std::string message);
    void logDebug(std::string message);

    void logError(FileLocation location, std::string message);
    void logWarn(FileLocation location, std::string message);
    void logDebug(FileLocation location, std::string message);

    /* Set filename of the file being processed */
    void setFilename(std::string f) { filename = f; }
    void setDebugEnabled(bool d) {debugEnabled = d;}
  };

} // namespace stark

#endif