#ifndef UTIL_LOGGER_H
#define UTIL_LOGGER_H

#include <string>

namespace stark
{

  /**
 * Logger
 */
  class Logger
  {
  public:
    bool debugEnabled;
    Logger() { debugEnabled = false; }
    virtual ~Logger() {}
    void logError(std::string message);
    void logWarn(std::string message);
    void logDebug(std::string message);
  };

} // namespace stark

#endif