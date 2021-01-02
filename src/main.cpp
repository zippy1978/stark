#include <iostream>
#include <fstream>
#include <cstdlib>
#include <FlexLexer.h>
#include "ast/AST.h"
#include "parser/parser.hpp"
#include "codeGen/CodeGen.h"

yyFlexLexer *lexer;
extern ASTBlock *programBlock;

int yylex(yy::parser::semantic_type *yylval, yy::parser::location_type *yylloc)
{
    yylloc->begin.line = lexer->lineno();
    int token = lexer->yylex();

    // This stores the value of tokens as string into yylval
    if (token == yy::parser::token::IDENTIFIER || token == yy::parser::token::INTEGER || token == yy::parser::token::DOUBLE)
    {
        yylval->string = new std::string(lexer->YYText());
    }

    // On a string : quotes must be removed (first and last char)
    if (token == yy::parser::token::STRING)
    {
        yylval->string = new std::string(lexer->YYText() + 1, lexer->YYLeng() - 2);
    }

    return token;
}

void yy::parser::error(const location_type &loc, const std::string &msg)
{
    std::cerr << "Line " << loc.begin.line << ": " << msg << std::endl;
    exit(1);
}

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
    lexer = new yyFlexLexer(&input);
    yy::parser parser;
    parser.parse();
    delete lexer;

    // Generate and run code
    CodeGenContext context;
    context.generateCode(*programBlock);
    context.runCode();

    return 0;
}
