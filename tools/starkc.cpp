#include <iostream>
#include <fstream>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>

#include <lang/ast/AST.h>
#include <lang/codeGen/CodeGen.h>
#include <lang/compiler/Compiler.h>
#include <lang/util/Util.h>
#include <lang/parser/StarkParser.h>
#include <runtime/Runtime.h>

#include "StarkConfig.h"

using namespace stark;

typedef struct
{
    bool debug;
    bool version;
    bool help;
    int argc;
    char **argv;
    bool error;
    char *outputFile;
    char *modulePath;
    char *runtimeLib;
    char *target;
    char *linker;

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
    std::cout << "  -h      Print help" << std::endl;
    std::cout << "  -r      Static Stark runtime (libstark.a) file name to use for compilation. If not provided, used the one defined by STARK_RUNTIME environment variable" << std::endl;
    std::cout << "  -m      Module search path: paths separated with colons (in addition to paths defined by STARK_MODULE_PATH environment variable)" << std::endl;
    std::cout << "  -t      Cross compilation target. Expected format is triple:cpu:features. If not provided, uses host target." << std::endl;
    std::cout << "  -l      Linker settings. Expected format is linker_command:linker_flags. If not provided, uses cc. Use 'none' value to disable linking." << std::endl;
}

void printVersion()
{
    std::cout << stark::format("Stark compiler version %s", Stark_VERSION) << std::endl;
    std::cout << stark::format("Target: %s", CodeGenBitcode::getHostTargetTriple().c_str()) << std::endl;
}

void parseOptions(int argc, char *argv[])
{
    // Parse options

    int index;
    int c;
    while ((c = getopt(argc, argv, "dvho:m:r:t:l:")) != -1)
        switch (c)
        {
        case 'd':
            options.debug = true;
            break;
        case 'v':
            options.version = true;
            break;
        case 'h':
            options.help = true;
            break;
        case 'o':
            options.outputFile = optarg;
            break;
        case 'r':
            options.runtimeLib = optarg;
            break;
        case 't':
            options.target = optarg;
            break;
        case 'l':
            options.linker = optarg;
            break;
        case 'm':
            options.modulePath = optarg;
            break;
        case '?':
            if (optopt == 'o' || optopt == 'm' || optopt == 'r' || optopt == 't' || optopt == 'l')
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
    if (!options.version && !options.help)
    {
        if (options.argc == 0)
        {
            std::cerr << "No input file" << std::endl;
            printUsage();
            options.error = true;
        }
        else if (options.outputFile == nullptr)
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
    // Init options
    options.debug = false;
    options.version = false;
    options.help = false;
    options.argc = 0;
    options.argv = nullptr;
    options.error = false;
    options.outputFile = nullptr;
    options.modulePath = nullptr;
    options.runtimeLib = nullptr;
    options.target = nullptr;
    options.linker = nullptr;

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
    else if (options.help)
    {
        // Print help
        printUsage();
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

        // Get module search paths
        std::vector<std::string> searchPaths;
        // Environement variable
        if (const char *modulePath = std::getenv("STARK_MODULE_PATH"))
        {
            searchPaths = split(modulePath, ':');
        }
        // -m parameter
        if (options.modulePath != nullptr)
        {
            std::vector<std::string> commandSearchPaths = split(options.modulePath, ':');
            searchPaths.insert(std::end(searchPaths), std::begin(commandSearchPaths), std::end(commandSearchPaths));
        }

        // Build each module
        for (auto it = modulesMap.begin(); it != modulesMap.end(); it++)
        {
            std::string moduleName = it->first;
            std::vector<std::string> moduleSourceFilenames = it->second;

            CompilerModuleBuilder moduleBuilder(moduleName, new CompilerModuleLoader(new CompilerModuleResolver(searchPaths)));
            moduleBuilder.setDebugEnabled(options.debug);
            moduleBuilder.addSourceFiles(moduleSourceFilenames);

            CompilerModule *module = moduleBuilder.build();

            // If compiling main module : outputs an executable
            if (containsMainModule)
            {
                // Get runtime static lib
                std::string runtimeStaticLib = "";
                if (options.runtimeLib != nullptr)
                {
                    runtimeStaticLib = options.runtimeLib;
                }
                else
                {
                    if (const char *runtimeLibEnv = std::getenv("STARK_RUNTIME"))
                    {
                        runtimeStaticLib = runtimeLibEnv;
                    }
                    else
                    {
                        std::cerr << "No stark runtime static lib provided. Either use the -r option, or set STARK_RUNTIME environment variable" << std::endl;
                        exit(1);
                    }
                }

                // Compile and link module with runtime and system libs
                // Link only if linking is not disabled
                if (options.linker != nullptr && std::string(options.linker).compare("none") == 0)
                {
                    std::string objectFile = options.outputFile;
                    objectFile.append(".o");
                    module->writeObjectCode(objectFile, options.target);
                }
                else
                {
                    CompilerSystemLinker systemLinker;
                    systemLinker.link(module, options.outputFile, runtimeStaticLib, CodeGenBitcode::getHostTargetTriple(), options.linker == nullptr ? "cc:" : options.linker);
                }

            }
            else
            {
                module->write(options.outputFile);
            }
            delete module;
        }
    }

    return 0;
}
