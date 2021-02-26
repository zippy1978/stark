#include <iostream>
#include <fstream>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <strstream>
#include <sys/stat.h>

#include "../ast/AST.h"
#include "../codeGen/CodeGen.h"
#include "../runtime/Runtime.h"
#include "../parser/StarkParser.h"

#include "CompilerModuleBuilder.h"

namespace stark
{
    void CompilerModuleBuilder::extractDeclarations()
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

    void CompilerModuleBuilder::extractExternalModules()
    {

        for (auto it = sourceASTs.begin(); it != sourceASTs.end(); it++)
        {
            std::string sourceFilename = it->first;
            ASTBlock *sourceBlock = it->second.get();

            std::vector<std::string> sourceExternalModules;

            externalModulesMap[sourceFilename] = moduleLoader.get()->extractModules(sourceBlock);
        }
    }

    std::vector<ASTBlock *> CompilerModuleBuilder::getDeclarationsFor(std::string filename)
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

    std::vector<ASTBlock *> CompilerModuleBuilder::getExternalModulesDeclarationsFor(std::string filename)
    {
        std::vector<ASTBlock *> result;

        std::vector<std::string> moduleNames = externalModulesMap[filename];
        for (auto it = moduleNames.begin(); it != moduleNames.end(); it++)
        {
            std::string moduleName = *it;

            ASTBlock *moduleDeclarationASTs = externalModulesDeclarationASTs[moduleName].get();
            if (moduleDeclarationASTs == nullptr)
            {
                // If AST not available yet : parse file and add it to map for next time
                CompilerModule *module = moduleLoader.get()->getModule(moduleName);
                StarkParser parser(filename);
                moduleDeclarationASTs = parser.parse(module->getHeaderCode());
                externalModulesDeclarationASTs[moduleName] = std::unique_ptr<ASTBlock>(moduleDeclarationASTs);
            }
            result.push_back(moduleDeclarationASTs);
        }

        return result;
    }

    void CompilerModuleBuilder::addSourceFile(std::string filename)
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

    void CompilerModuleBuilder::addSourceFiles(std::vector<std::string> filenames)
    {
        for (auto it = filenames.begin(); it != filenames.end(); it++)
        {
            addSourceFile(*it);
        }
    }

    CompilerModule *CompilerModuleBuilder::build()
    {

        logger.logDebug(format("compiling module %s", name.c_str()));

        linker.get()->setDebugEnabled(debugEnabled);

        // Load and parse runtime declarations
        StarkParser parser("runtime");
        ASTBlock *runtimeDeclarations = parser.parse(Runtime::getDeclarations());

        // Extract module declarations
        extractDeclarations();

        // Extract external modules
        extractExternalModules();

        for (auto it = sourceASTs.begin(); it != sourceASTs.end(); it++)
        {

            std::string sourceFilename = it->first;
            ASTBlock *sourceBlock = it->second.get();

            logger.logDebug(format("compiling %s", sourceFilename.c_str()));

            // Preprend other module sources declarations
            std::vector<ASTBlock *> declarations = getDeclarationsFor(sourceFilename);
            for (auto it2 = declarations.begin(); it2 != declarations.end(); it2++)
            {
                ASTBlock *block = *it2;
                sourceBlock->preprend(block);
            }

            // Prepend imported modules declarations
            std::vector<ASTBlock *> externalModulesDeclarations = getExternalModulesDeclarationsFor(sourceFilename);

            for (auto it2 = externalModulesDeclarations.begin(); it2 != externalModulesDeclarations.end(); it2++)
            {
                ASTBlock *block = *it2;

                sourceBlock->preprend(block);
            }

            // Prepend runtime declarations
            sourceBlock->preprend(runtimeDeclarations);

            // Sort root block to have declarations first (types, then external functions, then the rest)
            sourceBlock->sort();

            // Generate bitcode
            CodeGenFileContext *context = new CodeGenFileContext(sourceFilename);
            context->setDebugEnabled(debugEnabled);
            CodeGenBitcode *code = context->generateCode(sourceBlock);

            // Maintain context until module is compiled
            contexts.push_back(std::unique_ptr<CodeGenFileContext>(context));

            // Add to linker
            linker.get()->addBitcode(std::unique_ptr<CodeGenBitcode>(code));
        }

        delete runtimeDeclarations;

        // Link generated code
        logger.logDebug(format("linking module %s", name.c_str()));

        // Main module
        if (name.compare("main") == 0)
        {

            // Link main module with all external modules required
            std::vector<CompilerModule *> externalModules = moduleLoader.get()->getModules();
            for (auto it = externalModules.begin(); it != externalModules.end(); it++)
            {
                CompilerModule *m = *it;
                linker.get()->addBitcode(m->getBitcode());
            }

            CodeGenBitcode *moduleCode = linker.get()->link();
            return new CompilerModule(name, moduleCode, "");
        }
        // Other module : create directory layout
        else
        {
            CodeGenBitcode *moduleCode = linker.get()->link();

            // Merge declarations
            ASTBlock moduleDelcarations;
            for (auto it = declarationASTs.begin(); it != declarationASTs.end(); it++)
            {
                ASTBlock *d = it->second.get();
                moduleDelcarations.preprend(d);
            }
            moduleDelcarations.sort();

            // Generate .sth header
            ASTWriter writer;
            writer.visit(&moduleDelcarations);

            return new CompilerModule(name, moduleCode, writer.getSourceCode());
        }
    }

} // namespace stark