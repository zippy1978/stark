#ifndef PARSER_STARKPARSER_H
#define PARSER_STARKPARSER_H

#include "../ast/AST.h"

namespace stark
{
    class StarkParser
    {
        std::string filename;

    public:
        StarkParser(std::string filename) : filename(filename) {}
        ASTBlock *parse(std::istream *input);
        ASTBlock *parse(std::string input);
    };

} // namespace stark

#endif