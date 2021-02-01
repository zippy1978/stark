#ifndef COMPILER_COMPILERMODULE_H
#define COMPILER_COMPILERMODULE_H

#include <iostream>
#include <map>
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
        std::map<std::string, ASTBlock *> sourceASTs;
        std::map<std::string, ASTBlock *> declarationASTs;

        

        /* Display debug logs is enabled */
        bool debugEnabled = false;

        Logger logger;

    private:
        void extractDeclarations();
        std::vector<ASTBlock *> getDeclarationsFor(std::string filename);

    public:
        CompilerModule(std::string name) : name(name) {}
        /* Add source file to the module */
        void addSourceFile(std::string filename);
        void setDebugEnabled(bool d) { debugEnabled = d; }
        /* Compile module and output .bc to file */
        void compile(std::string filename);
    };

} // namespace stark

#endif