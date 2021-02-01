#include <iostream>
#include <fstream>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <strstream>

#include "ast/AST.h"
#include "parser/StarkParser.h"
#include "codeGen/CodeGen.h"
#include "runtime/Runtime.h"
#include "util/Util.h"
#include "compiler/Compiler.h"
#include "version.h"

using namespace stark;

typedef struct
{
    bool debug = false;
    bool version = false;
    int argc = 0;
    char **argv = NULL;
    bool error = false;
    char *outputfile = NULL;

} CommandOptions;

CommandOptions options;

void printUsage()
{
    std::cout << std::endl
              << "USAGE: starkc [options] filename" << std::endl;
    std::cout << std::endl
              << "OPTIONS:" << std::endl;
    std::cout << "  -o      Output file name" << std::endl;
    std::cout << "  -d      Enable debug mode" << std::endl;
    std::cout << "  -v      Print version information" << std::endl;
}

void printVersion()
{
    std::cout << stark::format("stark compiler version %s", VERSION_NUMBER) << std::endl;
}

void parseOptions(int argc, char *argv[])
{
    // Parse options

    int index;
    int c;
    while ((c = getopt(argc, argv, "dvo:")) != -1)
        switch (c)
        {
        case 'd':
            options.debug = true;
            break;
        case 'v':
            options.version = true;
            break;
        case 'o':
            options.outputfile = optarg;
            break;
        case '?':
            if (optopt == 'o')
                std::cerr << stark::format("Option -%c requires an argument.", optopt) << std::endl;
            else if (isprint(optopt))
                std::cerr << stark::format("Unknown option `-%c'.", optopt) << std::endl;
            else
                std::cerr << stark::format("Unknown option character `\\x%x'.", optopt) << std::endl;
            printUsage();
            options.error = true;
        default:
            abort();
        }

    // Get non option args
    options.argc = argc - optind;
    char **otherArgv = (char **)malloc(sizeof(char *) * options.argc);
    int i = 0;
    for (index = optind; index < argc; index++)
    {
        otherArgv[i] = (char *)malloc(strlen(argv[index]) + 1);
        strcpy(otherArgv[i], argv[index]);
        i++;
    }
    options.argv = otherArgv;
}

/**
 * Stark compiler command
 */
int main(int argc, char *argv[])
{
    // Parse options
    parseOptions(argc, argv);

    // If option parsing failed : return
    if (options.error)
    {
        return 1;
    }

    if (options.version)
    {
        // Print version
        printVersion();
    }
    else if (options.argc == 0)
    {
        // If not printing version : filename is required
        std::cerr << "filename is missing." << std::endl;
        printUsage();
        exit(1);
    }
    else
    {
        CompilerModule module("main");
        module.setDebugEnabled(options.debug);

        // Add source files to the module
        for (int i = 0; i < options.argc; i++)
        {
            module.addSourceFile(options.argv[i]);

        }

        // Determine output filename
        std::string outputFilename = options.argv[0];
        outputFilename = outputFilename.append(".bc");
        if (options.outputfile != NULL)
        {
            outputFilename = options.outputfile;
        }

        // Compile to file
        module.compile(outputFilename);

    }

    return 0;
}
