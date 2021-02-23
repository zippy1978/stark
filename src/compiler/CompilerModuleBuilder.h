#ifndef COMPILER_COMPILERMODULEBUILDER_H
#define COMPILER_COMPILERMODULEBUILDER_H

#include <iostream>
#include <map>
#include <vector>

#include "../util/Util.h"
#include "../ast/AST.h"

#include "CompilerModuleLoader.h"

namespace stark
{
    /**
     * Module builder.
     * Build a module from source files.
     */
    class CompilerModuleBuilder
    {
        std::string name;

        /** 
         * Map holding parsed sources AST.
         * Key is the source file name.
         * */
        std::map<std::string, std::unique_ptr<ASTBlock>> sourceASTs;

        /**
         * Map holding declarations AST (to export).
         * Key is the source file name.
         * */
        std::map<std::string, std::unique_ptr<ASTBlock>> declarationASTs;

        /**
         * Map holding external modules declarations AST.
         * Key is the module name.
         * */
        std::map<std::string, std::unique_ptr<ASTBlock>> externalModulesDeclarationASTs;

        /**
         * Map holding imported external modules for each source file of this module.
         * Key is the module name.
         * */
        std::map<std::string, std::vector<std::string>> externalModulesMap;

        /** 
         * Holds each source file context of the module
         * They must be retained until their bitcode has been linked
         * */
        std::vector<std::unique_ptr<CodeGenFileContext>> contexts;

        std::unique_ptr<CompilerModuleLoader> moduleLoader;

        /** Display debug logs if enabled */
        bool debugEnabled = false;

        Logger logger;

        std::unique_ptr<CodeGenBitcodeLinker> linker;

    private:
        void extractDeclarations();
        void extractExternalModules();
        std::vector<ASTBlock *> getDeclarationsFor(std::string filename);
        std::vector<ASTBlock *> getExternalModulesDeclarationsFor(std::string filename);

    public:
        CompilerModuleBuilder(std::string name, CompilerModuleLoader *moduleLoader) : name(name), moduleLoader(moduleLoader)
        {
            linker = std::make_unique<CodeGenBitcodeLinker>(name);
        }
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