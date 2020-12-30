#include <iostream>
#include <llvm/Support/FormatVariadic.h>

#include "CodeGenLogger.h"

using namespace llvm;

/* Logger */

void CodeGenLogger::logError(std::string message) {
    std::string outputMessage = formatv("ERROR: {0}", message);
    std::cerr << outputMessage << std::endl;
    // Error if fatal for compiler: exiting
    exit(1);
}

void CodeGenLogger::logWarn(std::string message) {
    std::string outputMessage = formatv("WARNING: {0}", message);
    std::cerr << outputMessage << std::endl;
}

void CodeGenLogger::logDebug(std::string message) {
    if (this->debugEnabled) {
        std::string outputMessage = formatv("DEBUG: {0}", message);
        std::cerr << outputMessage << std::endl;
    }
}