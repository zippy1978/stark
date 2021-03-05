#include <dirent.h>

#include "CompilerModuleResolver.h"

namespace stark
{
    CompilerModule *CompilerModuleResolver::resolve(std::string moduleName)
    {

        for (auto it = searchPaths.begin(); it != searchPaths.end(); it++)
        {
            std::string searchPath = *it;
            DIR *root = nullptr;
            struct dirent* ent = nullptr;

            root = opendir(searchPath.c_str());

            if (root != nullptr)
            {
                while ((ent = readdir(root)) != nullptr)
                {
                    if(ent->d_type == DT_DIR && moduleName.compare(ent->d_name) == 0)
                    {
                        closedir(root);
                        CompilerModule *module = new CompilerModule(moduleName);
                        module->load(searchPath.append("/").append(moduleName));
                        return module;
                    }
                }

                closedir(root);
            }
            else
            {
                logger.logWarn(format("cannot read from path %s", searchPath.c_str()));
            }
        }

        return nullptr;
    }
}
