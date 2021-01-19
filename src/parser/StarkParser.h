#ifndef PARSER_STARKPARSER_H
#define PARSER_STARKPARSER_H

#include "parser.hpp"

namespace stark
{
    class StarkParser
    {
        std::string filename;

    public:
        StarkParser(std::string filename) : filename(filename) {}
        ASTBlock *parse(std::istream *input);
    };

} // namespace stark

#endif