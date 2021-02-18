#include <iostream>
#include <fstream>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <strstream>
#include <stdbool.h>

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
    bool moduleMode = false;
    int argc = 0;
    char **argv = nullptr;
    bool error = false;
    char *outputfile = nullptr;

} CommandOptions;

CommandOptions options;

void printUsage()
{
    std::cout << std::endl
              << "USAGE: starkc [options] filename" << std::endl;
    std::cout << std::endl
              << "OPTIONS:" << std::endl;
    std::cout << "  -o      Output file name or directory name (for modules)" << std::endl;
    std::cout << "  -d      Enable debug mode" << std::endl;
    std::cout << "  -v      Print version information" << std::endl;
}

void printVersion()
{
    std::cout << stark::format("Stark compiler version %s", VERSION_NUMBER) << std::endl;
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

    // Check mandatory options
    if (!options.version)
    {
        if (options.argc == 0)
        {
            std::cerr << "No input file" << std::endl;
            printUsage();
            options.error = true;
        }
        else if (options.outputfile == nullptr)
        {
            std::cerr << "Option -o is mandatory" << std::endl;
            printUsage();
            options.error = true;
        }
    }
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

        // Source filenames vector
        std::vector<std::string> sourceFilenames;
        for (int i = 0; i < options.argc; i++)
        {
            sourceFilenames.push_back(options.argv[i]);
        }

        // Map modules
        CompilerModuleMapper mapper;
        mapper.setDebugEnabled(options.debug);
        std::map<std::string, std::vector<std::string>> modulesMap = mapper.map(sourceFilenames);

        // Do sources contain a main module ?
        bool containsMainModule = (modulesMap.find("main") != modulesMap.end());

        if (containsMainModule && modulesMap.size() > 1) 
        {
            std::cerr << "Cannot compile main executable and modules at the same time" << std::endl;
            exit(1);
        }
        

        // Build each module
        for (auto it = modulesMap.begin(); it != modulesMap.end(); it++)
        {
            std::string moduleName = it->first;
            std::vector<std::string> moduleSourceFilenames = it->second;

            CompilerModule module(moduleName);
            module.setDebugEnabled(options.debug);
            module.addSourceFiles(moduleSourceFilenames);

            module.compile(options.outputfile);
        }
    }

    return 0;
}
