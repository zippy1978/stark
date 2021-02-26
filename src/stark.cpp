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
#include "runtime/Runtime.h"
#include "codeGen/CodeGen.h"
#include "interpreter/Interpreter.h"
#include "compiler/Compiler.h"
#include "util/Util.h"
#include "version.h"

using namespace stark;

typedef struct
{
    bool debug = false;
    bool version = false;
    int argc = 0;
    char **argv = nullptr;
    bool error = false;
    char *modulePath = nullptr;

} CommandOptions;

CommandOptions options;

void printUsage()
{
    std::cout << std::endl
              << "USAGE: stark [options] filename [args]" << std::endl;
    std::cout << std::endl
              << "OPTIONS:" << std::endl;
    std::cout << "  -d      Enable debug mode" << std::endl;
    std::cout << "  -v      Print version information" << std::endl;
    std::cout << "  -m      Module search path: paths separated with colons (in addition to paths defined by STARK_MODULE_PATH environement variable)" << std::endl;
}

void printVersion()
{
    std::cout << stark::format("Stark interpreter version %s", VERSION_NUMBER) << std::endl;
}

void parseOptions(int argc, char *argv[])
{
    // Parse options

    int index;
    int c;
    while ((c = getopt(argc, argv, "dvm:")) != -1)
        switch (c)
        {
        case 'd':
            options.debug = true;
            break;
        case 'v':
            options.version = true;
            break;
        case 'm':
            options.modulePath = optarg;
            break;
        case '?':
            if (optopt == 'm')
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
 * Stark interpreter command
 * Runs code from a source file.
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

        // Run file...
        std::string filename = options.argv[0];
        // Read input file
        std::ifstream input(filename);
        if (!input)
        {
            std::cerr << "Cannot open input file: " << filename << std::endl;
            exit(1);
        }

        // Get module search paths
        std::vector<std::string> searchPaths;
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

        // Parse sources
        StarkParser parser(filename);
        ASTBlock *program = parser.parse(&input);

        // Load imported modules
        CompilerModuleLoader moduleLoader(new CompilerModuleResolver(searchPaths));
        std::vector<std::string> importedModules = moduleLoader.extractModules(program);

        // Prepend imported module headers to program
        for (auto it = importedModules.begin(); it != importedModules.end(); it++)
        {
            CompilerModule *m = moduleLoader.getModule(*it);
            StarkParser headerParser(m->getName());
            ASTBlock *headerAST = headerParser.parse(m->getHeaderCode());
            program->preprend(headerAST);
            delete headerAST;
        }

        // Load and parse runtime declarations
        StarkParser runtimeParser("runtime");
        ASTBlock *declarations = runtimeParser.parse(Runtime::getDeclarations());

        // ... And preprend it to the source AST
        program->preprend(declarations);
        delete declarations;

        // Generate code
        CodeGenFileContext context(filename);
        context.setDebugEnabled(options.debug);
        context.setInterpreterMode(true);
        CodeGenBitcode *code = context.generateCode(program);
        delete program;

        // Link modules
        CodeGenBitcodeLinker linker("main");
        linker.setDebugEnabled(options.debug);
        linker.addBitcode(std::unique_ptr<CodeGenBitcode>(code));
        std::vector<CompilerModule *> modules = moduleLoader.getModules();
        for (auto it = modules.begin(); it != modules.end(); it++)
        {
            CompilerModule *m = *it;
            linker.addBitcode(m->getBitcode());
        }
        CodeGenBitcode *linkedCode = linker.link();

        // Run code
        Interpreter interpreter;
        int result = interpreter.run(linkedCode, options.argc, options.argv);
        delete linkedCode;
        return result;
    }

    return 0;
}
