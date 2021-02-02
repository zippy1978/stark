#ifndef COMPILER_COMPILERMODULEMAPPER_H
#define COMPILER_COMPILERMODULEMAPPER_H

#include <iostream>
#include <map>
#include <vector>

#include "../util/Util.h"

namespace stark
{
    /**
     * Compiler module mapper.
     * Check module for provided source files.
     */
    class CompilerModuleMapper
    {

    public:
        CompilerModuleMapper() {}
        /** Add source file to the mapper */
        void addSourceFile(std::string filename);
        /** Analyse provided source files and return a map, 
         * where key is the module name, and value is a vector of sourcefile belonging to that module 
         * */
        std::map<std::string, std::vector<std::string>> map(std::vector<std::string> sourceFilenames);
    };

} // namespace stark

#endif