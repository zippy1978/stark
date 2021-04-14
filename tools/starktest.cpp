#include <iostream>
#include <fstream>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <chrono>

#include <lang/ast/AST.h>
#include <lang/codeGen/CodeGen.h>
#include <lang/interpreter/Interpreter.h>
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
    char *modulePath;
    char *interpreter;
    char *prefix;

} CommandOptions;

CommandOptions options;

void printUsage()
{
    std::cout << std::endl
              << "USAGE: starktest [options] filename [args]" << std::endl;
    std::cout << std::endl
              << "OPTIONS:" << std::endl;
    std::cout << "  -d      Enable debug mode" << std::endl;
    std::cout << "  -v      Print version information" << std::endl;
    std::cout << "  -h      Print help" << std::endl;
    std::cout << "  -m      Module search path: paths separated with colons (in addition to paths defined by STARK_MODULE_PATH environment variable)" << std::endl;
    std::cout << "  -i      Stark interpreter used to run tests. Default is 'stark'." << std::endl;
    std::cout << "  -p      Test function prefix. Default is 'test'." << std::endl;
}

void printVersion()
{
    std::cout << stark::format("Stark test runner version %s (%s)", Stark_VERSION, BUILD_TIME) << std::endl;
}

void parseOptions(int argc, char *argv[])
{
    // Parse options

    int index;
    int c;
    while ((c = getopt(argc, argv, "dvhm:i:p:")) != -1)
        switch (c)
        {
        case 'd':
            options.debug = true;
            break;
        case 'h':
            options.help = true;
            break;
        case 'v':
            options.version = true;
            break;
        case 'i':
            options.interpreter = optarg;
            break;
        case 'p':
            options.prefix = optarg;
            break;
        case 'm':
            options.modulePath = optarg;
            break;
        case '?':
            if (optopt == 'm' || optopt == 'i' || optopt == 'p')
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
    }
}

/**
 * Extract function definitions from an ASTBlock, where name match the provided prefix
 */
std::vector<ASTFunctionDefinition *> extractFunctions(ASTBlock *block, std::string prefix)
{
    std::vector<ASTFunctionDefinition *> result;
    ASTStatementList stmts = block->getStatements();
    for (auto it = stmts.begin(); it != stmts.end(); it++)
    {
        ASTStatement *stmt = *it;
        if (dynamic_cast<ASTFunctionDefinition *>(stmt))
        {
            ASTFunctionDefinition *fd = static_cast<ASTFunctionDefinition *>(stmt);
            if (fd->getId()->getName().rfind(prefix, 0) == 0)
            {
                result.push_back(fd);
            }
        }
    }
    return result;
}

/**
 * Stark interpreter command
 * Runs code from a source file.
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
    options.modulePath = nullptr;
    options.interpreter = (char *)"stark";
    options.prefix = (char *)"test";

    // Parse options
    parseOptions(argc, argv);

    int exitCode = 0;

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
    else
    {
        // Modules path
        std::string modulePaths = "";
        if (options.modulePath)
        {
            modulePaths = format("-m %s", options.modulePath);
        }

        int testFailedCount = 0;
        int testPassedCount = 0;
        long totalTime = 0;
        std::vector<std::string> testFilenames;
        for (int i = 0; i < options.argc; i++)
        {
            std::string filename = options.argv[i];
            testFilenames.push_back(filename);

            std::cout << "Running tests from " << filename << std::endl;

            // Read input file
            std::ifstream input(filename);
            if (!input)
            {
                std::cerr << "Cannot open input file: " << filename << std::endl;
                exit(1);
            }

            // Parse sources
            StarkParser parser(filename);
            ASTBlock *program = parser.parse(&input);

            // Retrieve test function names
            std::vector<ASTFunctionDefinition *> testFunctions = extractFunctions(program, options.prefix);

            // Run tests
            for (auto it = testFunctions.begin(); it != testFunctions.end(); it++)
            {
                ASTFunctionDefinition *fd = *it;
                std::string testFunctionName = fd->getId()->getName();
                std::cout << testFunctionName << " ... running\r" << std::flush;

                std::string testCommandLine = format("echo \"%s $(cat %s) %s()\" | %s %s",
                                                     Runtime::getTestDeclarations().c_str(),
                                                     filename.c_str(),
                                                     testFunctionName.c_str(),
                                                     options.interpreter,
                                                     modulePaths.c_str());
                Command cmd(testCommandLine);

                auto begin = std::chrono::high_resolution_clock::now();
                cmd.execute();
                auto end = std::chrono::high_resolution_clock::now();

                long elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(end - begin).count();
                totalTime += elapsedTime;

                if (cmd.getExitStatus() != 0)
                {
                    std::cout << testFunctionName << format(" ...  failed (%ld ms)\r", elapsedTime) << std::endl;
                    std::cout << cmd.getStdErr();
                    exitCode = 1;
                    testFailedCount++;
                }
                else
                {
                    std::cout << testFunctionName << format(" ...  passed (%ld ms)\r", elapsedTime) << std::endl;
                    testPassedCount++;
                }
            }

            delete program;
        }

        std::cout << format("%d test(s) run, passed: %d, failed: %d, time: %ld ms",
                            testPassedCount + testFailedCount,
                            testPassedCount,
                            testFailedCount,
                            totalTime)
                  << std::endl;
    }

    return exitCode;
}