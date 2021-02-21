#include <iostream>
#include <fstream>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <strstream>
#include <sys/stat.h>

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
            ASTBlock *sourceBlock = it->second.get();

            extractor.visit(sourceBlock);
            declarationASTs[sourceFilename] = std::unique_ptr<ASTBlock>(extractor.getDeclarationBlock()->clone());
        }
    }

    std::vector<ASTBlock *> CompilerModule::getDeclarationsFor(std::string filename)
    {
        std::vector<ASTBlock *> result;

        for (auto it = declarationASTs.begin(); it != declarationASTs.end(); it++)
        {
            std::string sourceFilename = it->first;
            ASTBlock *sourceBlock = it->second.get();

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
            logger.logError(format("cannot open input file: %s", filename.c_str()));
        }

        // Parse source file and add to module source ASTs
        StarkParser parser(filename);
        sourceASTs[filename] = std::unique_ptr<ASTBlock>(parser.parse(&input));
    }

    void CompilerModule::addSourceFiles(std::vector<std::string> filenames)
    {
        for (auto it = filenames.begin(); it != filenames.end(); it++)
        {
            addSourceFile(*it);
        }
    }

    void CompilerModule::compile(std::string filename)
    {

        logger.logDebug(format("compiling module %s", name.c_str()));

        CodeGenBitcodeLinker linker(this->name);
        linker.setDebugEnabled(debugEnabled);

        // Load and parse runtime declarations
        StarkParser parser("runtime");
        ASTBlock *runtimeDeclarations = parser.parse(Runtime::getDeclarations());

        // Extract module declarations
        extractDeclarations();

        for (auto it = sourceASTs.begin(); it != sourceASTs.end(); it++)
        {

            std::string sourceFilename = it->first;
            ASTBlock *sourceBlock = it->second.get();

            // Preprend other sources declarations
            std::vector<ASTBlock *> declarations = getDeclarationsFor(sourceFilename);
            for (auto it2 = declarations.begin(); it2 != declarations.end(); it2++)
            {
                ASTBlock *block = *it2;
                sourceBlock->preprend(block);
            }

            // Prepend runtime declarations
            sourceBlock->preprend(runtimeDeclarations);

            // Prempned imported modules declaration
            // TODO

            // Sort root block to have declarations first (types, then external functions, then the rest)
            sourceBlock->sort();

            // Generate bitcode
            CodeGenFileContext *context = new CodeGenFileContext(sourceFilename);
            context->setDebugEnabled(debugEnabled);
            CodeGenBitcode *code = context->generateCode(sourceBlock);

            // Maintain context until module is compiled
            contexts.push_back(std::unique_ptr<CodeGenFileContext>(context));

            // Add to linker
            linker.addBitcode(std::unique_ptr<CodeGenBitcode>(code));
        }

        delete runtimeDeclarations;

        // Link generated code
        logger.logDebug(format("linking module %s", name.c_str()));
        CodeGenBitcode *moduleCode = linker.link();

        // Write code

        // Main module
        if (name.compare("main") == 0)
        {
            moduleCode->write(filename);
        }
        // Other module : create directory layout
        else
        {
            std::string moduleDir = filename.append("/").append(name);
            if (mkdir(moduleDir.c_str(), 0700) == -1)
                logger.logError(format("cannot create directory %s (%s)", moduleDir.c_str(), strerror(errno)));

            // Write bitcode
            std::string bitcodeFilename = moduleDir;
            bitcodeFilename.append("/").append(name).append(".bc");
            moduleCode->write(bitcodeFilename);

            // Merge declarations
            ASTBlock moduleDelcarations;
            for (auto it = declarationASTs.begin(); it != declarationASTs.end(); it++)
            {
                ASTBlock *d = it->second.get();
                moduleDelcarations.preprend(d);
            }
            moduleDelcarations.sort();

            // Write .sth header
            ASTWriter writer;
            writer.visit(&moduleDelcarations);
            std::string sthSource = writer.getSourceCode();
            logger.logDebug(format("generated .sth : \n%s", sthSource.c_str()));
            std::string sthFilename = moduleDir;
            sthFilename.append("/").append(name).append(".sth");
            std::ofstream out(sthFilename);
            if (!out.is_open())
            {
                logger.logError(format("failed to create file %s", sthFilename.c_str()));
            }
            out << sthSource;
            out.close();
        }

        delete moduleCode;
    }

} // namespace stark