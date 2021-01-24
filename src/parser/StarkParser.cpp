#include <FlexLexer.h>
#include "../ast/AST.h"
#include "../util/Util.h"

#include "StarkParser.h"

// TODO : find a way to get rid of those globals !
yyFlexLexer *lexer;
stark::Logger parserLogger;
extern stark::ASTBlock *programBlock;

int yylex(yy::parser::semantic_type *yylval, yy::parser::location_type *yylloc)
{
    yylloc->begin.line = lexer->lineno();
    int token = lexer->yylex();

    // This stores the value of tokens as string into yylval
    if (token == yy::parser::token::IDENTIFIER || token == yy::parser::token::INTEGER || token == yy::parser::token::DOUBLE)
    {
        yylval->string = new std::string(lexer->YYText());
        std::cout << lexer->YYText() << " line " << lexer->lineno() << std::endl;
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
    stark::FileLocation location(loc.begin.line, loc.begin.column);
    parserLogger.logError(location, msg);
}

namespace stark
{
    ASTBlock *StarkParser::parse(std::istream *input)
    {
        parserLogger.setFilename(filename);
        lexer = new yyFlexLexer(input);
        yy::parser parser;
        parser.parse();
        delete lexer;

        return programBlock;
    }
} // namespace stark