#ifndef CODEGEN_CODEGENLOGGER_H
#define CODEGEN_CODEGENLOGGER_H

#include <string>

/**
 * Code generation logger
 */
class CodeGenLogger {
  public:
    bool debugEnabled;
    CodeGenLogger() { debugEnabled = false; }
    virtual ~CodeGenLogger() {}
    void logError(std::string message);
    void logWarn(std::string message);
    void logDebug(std::string message);
};

#endif