#include <lang/util/Util.h>

#include "CompilerSystemLinker.h"

namespace stark
{
    void CompilerSystemLinker::link(CompilerModule *module, std::string filename, std::string runtimeStaticLibFilename)
    {
        logger.setFilename("linker");

        // Check if runtime file exists
        if (!stark::fileExists(runtimeStaticLibFilename))
        {
            logger.logError(format("%s runtime not found", runtimeStaticLibFilename.c_str()));
        }

        // Compile object file
        std::string objectFile = filename;
        objectFile.append(".o");
        module->writeObjectCode(objectFile);

        // Call system linker
        std::string linkerCommandLine = format("cc -pthread -o %s %s %s", filename.c_str(), objectFile.c_str(), runtimeStaticLibFilename.c_str());
        Command cmd(linkerCommandLine);
        cmd.execute();
        if (cmd.getExitStatus() != 0)
        {
            logger.logError(cmd.getStdErr());
        }
    }
}
