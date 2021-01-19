#ifndef UTIL_LOGGER_H
#define UTIL_LOGGER_H

#include <string>

namespace stark
{

  /** 
   * Represent a log position (in a source file).
   */
  class LogPosition
  {
  public:
    int line = 0;
    int column = 0;
  };

  /**
 * Logger
 */
  class Logger
  {
    std::string *filename = NULL;

  private:
    std::string buildMessage(std::string typeName, LogPosition pos, std::string message);

  public:
    bool debugEnabled;
    Logger() { debugEnabled = false; }
    virtual ~Logger() {}
    void logError(std::string message);
    void logWarn(std::string message);
    void logDebug(std::string message);

    void logError(LogPosition pos, std::string message);
    void logWarn(LogPosition pos, std::string message);
    void logDebug(LogPosition pos, std::string message);

    /* Set filename of the file being processed */
    void setFilename(std::string f) { filename = &f; }
  };

} // namespace stark

#endif