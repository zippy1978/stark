#include <iostream>
#include <fstream>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <strstream>

#include "ast/AST.h"
#include "parser/StarkParser.h"
#include "runtime/Runtime.h"
#include "codeGen/CodeGen.h"
#include "util/Util.h"
#include "version.h"

using namespace stark;

typedef struct
{
    bool debug = false;
    bool version = false;
    int argc = 0;
    char **argv = NULL;
    bool error = false;

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
}

void printVersion()
{
    std::cout << stark::format("stark interpreter version %s", VERSION_NUMBER) << std::endl;
}

void parseOptions(int argc, char *argv[])
{
    // Parse options

    int index;
    int c;
    while ((c = getopt(argc, argv, "dv")) != -1)
        switch (c)
        {
        case 'd':
            options.debug = true;
            break;
        case 'v':
            options.version = true;
            break;
        case '?':
            if (isprint(optopt))
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

        // Parse sources
        StarkParser parser(filename);
        ASTBlock *program = parser.parse(&input);

        // Load and parse runtime declarations
        StarkParser runtimeParser("runtime");
        std::string runtimeDeclarations = Runtime::getDeclarations();
        std::istrstream istr(runtimeDeclarations.c_str());
        ASTBlock *declarations = parser.parse(&istr);

        // ... And preprend it to the source AST
        program->statements.insert(program->statements.begin(), declarations->statements.begin(), declarations->statements.end());

        // Generate and run code
        CodeGenContext context(filename);
        context.setDebugEnabled(options.debug);
        context.setInterpreterMode(true);
        context.generateCode(*program);
        return context.runCode(options.argc, options.argv);
    }

    return 0;
}
