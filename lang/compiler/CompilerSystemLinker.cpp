#include <lang/util/Util.h>

#include "CompilerSystemLinker.h"

namespace stark
{
    void CompilerSystemLinker::link(CompilerModule *module, std::string filename, std::string runtimeStaticLibFilename)
    {
        this->link(module, filename, runtimeStaticLibFilename, CodeGenBitcode::getHostTargetTriple(), "cc:-lpthread");
    }

    void CompilerSystemLinker::link(CompilerModule *module, std::string filename, std::string runtimeStaticLibFilename, std::string targetString, std::string linkerString)
    {
        logger.setFilename("linker");

        // Check if runtime file exists
        if (!stark::fileExists(runtimeStaticLibFilename))
        {
            logger.logError(format("%s runtime not found", runtimeStaticLibFilename.c_str()));
        }

        // Parse linkerString
        std::vector<std::string> linkerParts = split(linkerString, ':');
        std::string linkerCommand = "cc";
        if (linkerParts[0].size() > 0)
        {
            linkerCommand = linkerParts[0];
        }
        std::string linkerFlags = "-lpthread";
        if (linkerParts.size() > 1 && linkerParts[1].size() > 0)
        {
            linkerFlags = linkerParts[1];
        }

        // Compile object file
        std::string objectFile = filename;
        objectFile.append(".o");
        module->writeObjectCode(objectFile, targetString);

        // Call system linker
        std::string linkerCommandLine = format("%s -o %s %s %s %s", linkerCommand.c_str(), filename.c_str(), objectFile.c_str(), runtimeStaticLibFilename.c_str(), linkerFlags.c_str());
        Command cmd(linkerCommandLine);
        cmd.execute();
        if (cmd.getExitStatus() != 0)
        {
            logger.logError(cmd.getStdErr());
        }
    }
}
