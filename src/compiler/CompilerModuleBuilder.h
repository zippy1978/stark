#ifndef COMPILER_COMPILERMODULEBUILDER_H
#define COMPILER_COMPILERMODULEBUILDER_H

#include <iostream>
#include <map>
#include <vector>

#include "../util/Util.h"
#include "../ast/AST.h"

#include "CompilerModule.h"

namespace stark
{
    /**
     * Module builder.
     * Build a module from source files.
     */
    class CompilerModuleBuilder
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

        std::unique_ptr<CodeGenBitcodeLinker> linker;

    private:
        void extractDeclarations();
        std::vector<ASTBlock *> getDeclarationsFor(std::string filename);

    public:
        CompilerModuleBuilder(std::string name) : name(name) { linker = std::make_unique<CodeGenBitcodeLinker>(name); }
        /** Add source file to the module */
        void addSourceFile(std::string filename);
        void addSourceFiles(std::vector<std::string> filenames);
        void setDebugEnabled(bool d)
        {
            debugEnabled = d;
            logger.setDebugEnabled(d);
        }
        /** 
         * Build module.
         */
        CompilerModule *build();
    };

} // namespace stark

#endif