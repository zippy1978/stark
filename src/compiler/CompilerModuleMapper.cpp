#include <iostream>
#include <fstream>

#include "../ast/AST.h"
#include "../parser/StarkParser.h"
#include "CompilerModuleMapper.h"

namespace stark
{
    std::map<std::string, std::vector<std::string>> CompilerModuleMapper::map(std::vector<std::string> sourceFilenames)
    {
        logger.logDebug("Analyzing modules");

        std::map<std::string, std::vector<std::string>> result;

        for (auto it = sourceFilenames.begin(); it != sourceFilenames.end(); it++)
        {
            std::string sourceFilename = *it;

            std::ifstream input(sourceFilename);
            if (!input)
            {
                logger.logError(format("Cannot open input file: %s", sourceFilename.c_str()));
            }

            StarkParser parser(sourceFilename);
            ASTBlock *block = parser.parse(&input);

            bool hasModule = false;
            if (block->getStatements().size() > 0)
            {
                if (dynamic_cast<ASTModuleDeclaration *>(block->getStatements()[0]))
                {
                    ASTModuleDeclaration *d = static_cast<ASTModuleDeclaration *>(block->getStatements()[0]);
                    result[d->getId()->getFullName()].push_back(sourceFilename);
                    hasModule = true;
                }
            }

            // If no module declaration : source belongs to the main module
            if (!hasModule)
            {
                result["main"].push_back(sourceFilename);
            }

            delete block;
        }

        logger.logDebug(format("%d modules found", result.size()));

        return result;
    }

} // namespace stark