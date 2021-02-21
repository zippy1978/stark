#include <iostream>
#include <fstream>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <strstream>
#include <sys/stat.h>

#include "CompilerModule.h"

namespace stark
{
    void CompilerModule::write(std::string filename)
    {
        // Write module to a directory if it has a header
        if (headerCode.compare("") != 0)
        {
            std::string moduleDir = filename.append("/").append(name);

            if (mkdir(moduleDir.c_str(), 0700) == -1)
                throw format("cannot create directory %s (%s)", moduleDir.c_str(), strerror(errno));

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
                throw format("failed to create file %s", sthFilename.c_str());
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
}
