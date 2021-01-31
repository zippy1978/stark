#ifndef COMPILER_COMPILERMODULE_H
#define COMPILER_COMPILERMODULE_H

#include <iostream>
#include <vector>

#include "../util/Util.h"

namespace stark
{
    /**
     * Represents a stark module.
     */
    class CompilerModule
    {
        std::string name;
        std::vector<std::string> sourceFiles;

        /* Display debug logs is enabled */
        bool debugEnabled = false;

        Logger logger;

    public:
        CompilerModule(std::string name) : name(name) {}
        /* Add source file to the module */
        void addSourceFile(std::string filename) { sourceFiles.push_back(filename); }
        void setDebugEnabled(bool d) { debugEnabled = d; }
        /* Compile module and output .bc to file */
        void compile(std::string filename);
    };

} // namespace stark

#endif