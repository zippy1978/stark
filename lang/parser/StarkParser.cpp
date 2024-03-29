#include <strstream>
#include <string>
#include <regex>
#include <stdlib.h>
#include <FlexLexer.h>
#include "../ast/AST.h"
#include "../util/Util.h"
#include "parser.hpp"

#include "StarkParser.h"

// TODO : find a way to get rid of those globals !
yyFlexLexer *lexer;
stark::Logger parserLogger;
extern stark::ASTBlock *programBlock;

int yylex(yy::parser::semantic_type *yylval, yy::parser::location_type *yylloc)
{
    int token = lexer->yylex();

    // This stores the value of tokens as string into yylval
    if (token == yy::parser::token::IDENTIFIER || token == yy::parser::token::INTEGER || token == yy::parser::token::DOUBLE)
    {
        yylval->string = new std::string(lexer->YYText());
    }

    // On a string : quotes must be removed (first and last char)
    // Also : unescape string 
    if (token == yy::parser::token::STRING)
    {
        std::string s(lexer->YYText() + 1, lexer->YYLeng() - 2); 
        yylval->string = new std::string(stark::unescape(s));
    }

    // Must be set at the end otherwise does not work
    yylloc->begin.line = lexer->lineno();

    return token;
}

void yy::parser::error(const location_type &loc, const std::string &msg)
{
    stark::FileLocation location(loc.begin.line, loc.begin.column);
    parserLogger.logError(location, msg);
}

namespace stark
{
    ASTBlock *StarkParser::parse(std::istream *input)
    {
        //ASTBlock *programBlock;

        parserLogger.setFilename(filename);
        lexer = new yyFlexLexer(input);
        yy::parser parser/*(programBlock)*/;
        parser.parse();
        delete lexer;

        ASTBlock *result = programBlock->clone();
        delete programBlock;
        return result;
    }

    ASTBlock *StarkParser::parse(std::string input)
    {
        //ASTBlock *programBlock;

        parserLogger.setFilename(filename);
        std::istrstream istr(input.c_str());
        lexer = new yyFlexLexer(&istr);
        yy::parser parser/*(programBlock)*/;
        parser.parse();
        delete lexer;

        ASTBlock *result = programBlock->clone();
        delete programBlock;
        return result;
    }

    
} // namespace stark