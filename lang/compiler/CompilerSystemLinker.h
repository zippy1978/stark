#ifndef COMPILER_COMPILERSYSTEMLINKER_H
#define COMPILER_COMPILERSYSTEMLINKER_H

#include "../util/Util.h"

#include "CompilerModule.h"

namespace stark
{
    /**
     * System linker.
     * In charge of calling the system linking to turn object code to executable.
     */
    class CompilerSystemLinker
    {        
        Logger logger;

    public:
        CompilerSystemLinker() {}

        /** 
         * Link module to the stytem and write executable to the given filename. 
         * Also, the runtime static lib filename to use must be provided.
         */
        void link(CompilerModule *module, std::string filename, std::string runtimeStaticLibFilename);
    };

} // namespace stark

#endif