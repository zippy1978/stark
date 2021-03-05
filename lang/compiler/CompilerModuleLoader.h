#ifndef COMPILER_COMPILERMODULELOADER_H
#define COMPILER_COMPILERMODULELOADER_H

#include <iostream>
#include <map>
#include <vector>

#include "../util/Util.h"
#include "../ast/AST.h"

#include "CompilerModuleResolver.h"
#include "CompilerModule.h"

namespace stark
{
    /**
     * In charge of extracting and loading modules from source files.
     */
    class CompilerModuleLoader
    {
        /** Logger. */
        Logger logger;

        /** Module resolver. */
        std::unique_ptr<CompilerModuleResolver> resolver;

        /**
         * Map holding extracted modules.
         * Key is the module name.
         */
        std::map<std::string, std::unique_ptr<CompilerModule>> modules;

    public:
        CompilerModuleLoader(CompilerModuleResolver *resolver) : resolver(resolver) {}
        /** 
         * Extract modules from an AST block. 
         * Call is recursive: all transitive modules are loaded.
         * Returns directly loaded module names (not transitive modules).
         */
        std::vector<std::string> extractModules(ASTBlock *block);

        /** 
         * Get a loaded module by name.
         * Returns nullptr if module not loaded.
         */
        CompilerModule *getModule(std::string name) { return modules[name].get(); }

        /**
         * Get loaded modules
         */
        std::vector<CompilerModule *> getModules();
    };

} // namespace stark

#endif