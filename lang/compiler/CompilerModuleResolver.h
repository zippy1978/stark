#ifndef COMPILER_COMPILERMODULERESOLVER_H
#define COMPILER_COMPILERMODULERESOLVER_H

#include "../util/Util.h"

#include "CompilerModule.h"

namespace stark
{
    /**
     * Resolver, in charge of locating and loading modules.
     */
    class CompilerModuleResolver
    {
        std::vector<std::string> searchPaths;

        Logger logger;

    public:
        CompilerModuleResolver(std::vector<std::string> searchPaths) : searchPaths(searchPaths) {}
        CompilerModule *resolve(std::string moduleName);
    };

} // namespace stark

#endif