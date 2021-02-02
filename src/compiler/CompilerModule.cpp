#include <iostream>
#include <fstream>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <strstream>

#include "../codeGen/CodeGen.h"
#include "../runtime/Runtime.h"
#include "../parser/StarkParser.h"

#include "CompilerModule.h"

namespace stark
{
    void CompilerModule::extractDeclarations()
    {
        for (auto it = sourceASTs.begin(); it != sourceASTs.end(); it++)
        {
            ASTDeclarationExtractor extractor;

            std::string sourceFilename = it->first;
            ASTBlock *sourceBlock = it->second;

            extractor.visit(sourceBlock);
            declarationASTs[sourceFilename] = extractor.getDeclarationBlock();
        }
    }

    std::vector<ASTBlock *> CompilerModule::getDeclarationsFor(std::string filename)
    {
        std::vector<ASTBlock *> result;

        for (auto it = declarationASTs.begin(); it != declarationASTs.end(); it++)
        {
            std::string sourceFilename = it->first;
            ASTBlock *sourceBlock = it->second;

            if (filename.compare(sourceFilename) != 0)
            {
                result.push_back(sourceBlock);
            }
        }

        return result;
    }

    void CompilerModule::addSourceFile(std::string filename)
    {
        // Read input file
        std::ifstream input(filename);
        if (!input)
        {
            logger.logError(format("Cannot open input file: %s", filename.c_str()));
        }

        // Parse source file and add to module source ASTs
        StarkParser parser(filename);
        sourceASTs[filename] = parser.parse(&input);
    }

    void CompilerModule::addSourceFiles(std::vector<std::string> filenames)
    {
        for (auto it = filenames.begin(); it != filenames.end(); it++)
        {
            addSourceFile(*it);
        }
    }

    void CompilerModule::compile(std::string filename, bool singleMode)
    {
        CodeGenModuleLinker linker(this->name);

        // Load and parse runtime declarations
        StarkParser parser("runtime");
        ASTBlock *runtimeDeclarations = parser.parse(Runtime::getDeclarations());

        // Extract module declarations
        extractDeclarations();

        for (auto it = sourceASTs.begin(); it != sourceASTs.end(); it++)
        {

            std::string sourceFilename = it->first;
            ASTBlock *sourceBlock = it->second;

            // Preprend other sources declarations
            std::vector<ASTBlock *> declarations = getDeclarationsFor(sourceFilename);
            for (auto it2 = declarations.begin(); it2 != declarations.end(); it2++)
            {
                ASTBlock *block = *it2;
                sourceBlock->preprend(block);
            }

            // Prepend runtime declarations
            sourceBlock->preprend(runtimeDeclarations);

            // Generate IR
            CodeGenContext *context = new CodeGenContext(sourceFilename);
            context->setDebugEnabled(debugEnabled);
            context->generateCode(*sourceBlock);

            // Add to linker
            linker.addContext(context);
        }

        // Link generated code
        linker.link();

        // Write code
        // TODO : if not singleMode, handle module packaging !
        linker.writeCode(filename);
    }

} // namespace stark