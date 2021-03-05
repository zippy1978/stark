#include "../parser/StarkParser.h"

#include "CompilerModuleLoader.h"

namespace stark
{
    std::vector<std::string> CompilerModuleLoader::extractModules(ASTBlock *block)
    {
        ASTStatementList sts = block->getStatements();
        std::vector<std::string> moduleNames;
        for (auto it = sts.begin(); it != sts.end(); it++)
        {
            if (dynamic_cast<ASTImportDeclaration *>(*it))
            {
                ASTImportDeclaration *i = static_cast<ASTImportDeclaration *>(*it);
                std::string moduleName = i->getId()->getFullName();

                // Resolve module
                CompilerModule *module = resolver.get()->resolve(moduleName);

                if (module == nullptr)
                {
                    logger.logError(format("cannot find module %s", moduleName.c_str()));
                }

                // Parse module header and do recursive call
                StarkParser parser(module->getName().append(".sth"));
                ASTBlock *headerAST = parser.parse(module->getHeaderCode());
                extractModules(headerAST);
                delete headerAST;

                // Add loaded module to externalModules map
                if (modules[moduleName].get() == nullptr)
                {
                    modules[moduleName] = std::unique_ptr<CompilerModule>(module);
                }

                // Add module name to result vector
                moduleNames.push_back(moduleName);
            }
        }

        return moduleNames;
    }

    std::vector<CompilerModule *> CompilerModuleLoader::getModules()
    {
        std::vector<CompilerModule *> result;

        for(auto it = modules.begin(); it != modules.end(); it++)
        {
            CompilerModule *m = it->second.get();
            result.push_back(m);
        }

        return result;
    }

}
