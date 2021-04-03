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
         * The runtime static lib filename to use must be provided.
         * targetString is the compilation target: triple:cpu:features.
         * linkerString is the linker parameter string : linker_commad:linker_flags
         */
        void link(CompilerModule *module, std::string filename, std::string runtimeStaticLibFilename, std::string targetString, std::string linkerString);

        /** 
         * Link module to the stytem and write executable to the given filename. 
         * The runtime static lib filename to use must be provided.
         * Default linker paramaters are used (command and flags).
         */
        void link(CompilerModule *module, std::string filename, std::string runtimeStaticLibFilename);
    };

} // namespace stark

#endif