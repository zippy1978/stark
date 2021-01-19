#include <iostream>
#include <fstream>

#include "ast/AST.h"
#include "parser/StarkParser.h"
#include "codeGen/CodeGen.h"

using namespace stark;

extern ASTBlock *programBlock;

/**
 * Stark interpreter command
 * Runs code from a source file
 */
int main(int argc, char *argv[])
{

    if (argc != 2)
    {
        std::cerr << "Usage: " << argv[0] << " inputfile" << std::endl;
        exit(1);
    }

    std::ifstream input(argv[1]);
    if (!input)
    {
        std::cerr << "Cannot open input file: " << argv[1] << std::endl;
        exit(1);
    }

    // Parse sources
    StarkParser parser(argv[1]);
    parser.parse(&input);

    // Generate and run code
    CodeGenContext context;
    context.generateCode(*programBlock);
    context.runCode();

    // TODO : return what code generated
    return 0;
}
