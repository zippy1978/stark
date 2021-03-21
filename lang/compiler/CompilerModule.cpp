#include <iostream>
#include <fstream>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>

#include "CompilerModule.h"

namespace stark
{
    void CompilerModule::writeObjectCode(std::string filename)
    {
        bitcode.get()->writeObjectCode(filename);
    }

    void CompilerModule::write(std::string filename)
    {
        // Write module to a directory if it has a header
        if (headerCode.compare("") != 0)
        {
            std::string moduleDir = filename.append("/").append(name);

            if (mkdir(moduleDir.c_str(), 0700) == -1)
                logger.logError(format("cannot create directory %s (%s)", moduleDir.c_str(), strerror(errno)));

            // Write bitcode
            std::string bitcodeFilename = moduleDir;
            bitcodeFilename.append("/").append(name).append(".bc");
            bitcode.get()->write(bitcodeFilename);

            // Write .sth header
            std::string sthFilename = moduleDir;
            sthFilename.append("/").append(name).append(".sth");
            std::ofstream out(sthFilename);
            if (!out.is_open())
            {
                logger.logError(format("failed to create file %s", sthFilename.c_str()));
            }
            out << headerCode;
            out.close();
        }
        // Without header : outputs directly to the file name
        else
        {
            bitcode.get()->write(filename);
        }
    }

    void CompilerModule::load(std::string filename)
    {
        struct stat buf;
        stat(filename.c_str(), &buf);
        bool isDirectory = S_ISDIR(buf.st_mode);

        // If filename is a file
        if (!isDirectory)
        {
            // Load bitcode
            bitcode = std::make_unique<CodeGenBitcode>(nullptr);
            bitcode.get()->load(filename);
        }
        // If filename is a directory
        else
        {
            // Load bitcode
            bitcode = std::make_unique<CodeGenBitcode>(nullptr);
            std::string bitcodePath = filename;
            bitcodePath.append("/").append(name).append(".bc");
            bitcode.get()->load(bitcodePath);

            // Load header code
            std::string headerPath = filename;
            headerPath.append("/").append(name).append(".sth");
            std::ifstream t(headerPath);
            std::string str((std::istreambuf_iterator<char>(t)),
                            std::istreambuf_iterator<char>());
            headerCode = str;
        }
    }
}
