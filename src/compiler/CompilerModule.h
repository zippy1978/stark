#ifndef COMPILER_COMPILERMODULE_H
#define COMPILER_COMPILERMODULE_H

#include <iostream>
#include <map>
#include <vector>

#include "../util/Util.h"
#include "../ast/AST.h"

namespace stark
{
    /**
     * Represents a stark module.
     */
    class CompilerModule
    {
        std::string name;
        std::map<std::string, std::unique_ptr<ASTBlock>> sourceASTs;
        std::map<std::string, std::unique_ptr<ASTBlock>> declarationASTs;

        /** Holds each source file context of the module
         * They must be retained until their bitcode has been linked
         * */
        std::vector<std::unique_ptr<CodeGenFileContext>> contexts;

        /** Display debug logs if enabled */
        bool debugEnabled = false;

        Logger logger;

    private:
        void extractDeclarations();
        std::vector<ASTBlock *> getDeclarationsFor(std::string filename);

    public:
        CompilerModule(std::string name) : name(name) {}
        /** Add source file to the module */
        void addSourceFile(std::string filename);
        void addSourceFiles(std::vector<std::string> filenames);
        void setDebugEnabled(bool d)
        {
            debugEnabled = d;
            logger.setDebugEnabled(d);
        }
        /** 
         * Compile module and output result to file name (can be a directory).
         * set singleMode to true to build .bc as a file name
         */
        void compile(std::string filename);
    };

} // namespace stark

#endif