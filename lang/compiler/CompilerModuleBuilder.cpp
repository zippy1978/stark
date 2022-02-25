#include <iostream>
#include <fstream>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>

#include <runtime/Runtime.h>

#include "../ast/AST.h"
#include "../codeGen/CodeGen.h"
#include "../parser/StarkParser.h"
#include "../util/StringUtil.h"

#include "CompilerModuleBuilder.h"

namespace stark
{
    std::map<std::string, std::unique_ptr<ASTBlock>> CompilerModuleBuilder::extractDeclarationsForTargetModule(std::string targetModuleName)
    {
        std::map<std::string, std::unique_ptr<ASTBlock>> result;
        for (auto it = sourceASTs.begin(); it != sourceASTs.end(); it++)
        {
            ASTDeclarationExtractor extractor(targetModuleName);

            std::string sourceFilename = it->first;
            ASTBlock *sourceBlock = it->second.get();

            extractor.visit(sourceBlock);
            result[sourceFilename] = std::unique_ptr<ASTBlock>(extractor.getDeclarationBlock()->clone());
        }

        return result;
    }

    void CompilerModuleBuilder::extractDeclarations()
    {
        declarationASTs = extractDeclarationsForTargetModule(name);
    }

    void CompilerModuleBuilder::extractExternalModules()
    {

        // Find and load imported modules for each source file of the module
        for (auto it = sourceASTs.begin(); it != sourceASTs.end(); it++)
        {
            std::string sourceFilename = it->first;
            ASTBlock *sourceBlock = it->second.get();

            std::vector<std::string> sourceExternalModules;

            moduleLoader->extractModules(sourceBlock);
        }

        // Generate external modules declaration AST block
        externalModulesDelcarationsAST = std::make_unique<ASTBlock>();
        std::vector<CompilerModule *> modules = moduleLoader->getModules();
        for (auto it = modules.begin(); it != modules.end(); it++)
        {
            CompilerModule *module = *it;
            StarkParser parser("modules");
            ASTBlock *declarations = parser.parse(module->getHeaderCode());
            externalModulesDelcarationsAST->preprend(declarations);
            delete declarations;
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

            // Working on a source block copy because it will be modified during the process
            std::unique_ptr<ASTBlock> sourceBlock = std::unique_ptr<ASTBlock>(it->second.get()->clone());

            logger.logDebug(format("compiling %s", sourceFilename.c_str()));

            // Preprend other module sources declarations
            std::vector<ASTBlock *> declarations = getDeclarationsFor(sourceFilename);
            for (auto it2 = declarations.begin(); it2 != declarations.end(); it2++)
            {
                ASTBlock *block = *it2;
                sourceBlock->preprend(block);
            }

            // Prepend imported modules declarations
            sourceBlock->preprend(externalModulesDelcarationsAST.get());

            // Prepend runtime declarations
            sourceBlock->preprend(runtimeDeclarations);

            // Sort root block to have declarations first (types, then external functions, then the rest)
            sourceBlock->sort();

            // Generate bitcode
            CodeGenFileContext *context = new CodeGenFileContext(sourceFilename);
            context->setDebugEnabled(debugEnabled);
            CodeGenBitcode *code = context->generateCode(sourceBlock.get());

            // Maintain context until module is compiled
            contexts.push_back(std::unique_ptr<CodeGenFileContext>(context));

            // Add to linker
            linker->addBitcode(std::unique_ptr<CodeGenBitcode>(code));
        }

        delete runtimeDeclarations;

        // Link generated code
        logger.logDebug(format("linking module %s", name.c_str()));

        // Main module
        if (name.compare("main") == 0)
        {

            // Link main module with all external modules required
            std::vector<CompilerModule *> externalModules = moduleLoader->getModules();
            for (auto it = externalModules.begin(); it != externalModules.end(); it++)
            {
                CompilerModule *m = *it;
                linker->addBitcode(m->getBitcode());
            }

            CodeGenBitcode *moduleCode = linker->link();

            // FIXME : hangs compilation and segfaults !
            // Optimize code before linking
            /*CodeGenOptimizer optimizer;
            optimizer.setDebugEnabled(debugEnabled);
            optimizer.optimize(moduleCode);*/

            return new CompilerModule(name, moduleCode, "");
        }
        // Other module : create directory layout
        else
        {
            CodeGenBitcode *moduleCode = linker->link();

            // Merge declarations
            // Declarations must be re-extracted from the module for external linking
            std::map<std::string, std::unique_ptr<ASTBlock>> publicDeclarations(std::move(extractDeclarationsForTargetModule("main")));
            ASTBlock moduleDelcarations;
            for (auto it = publicDeclarations.begin(); it != publicDeclarations.end(); it++)
            {
                ASTBlock *d = it->second.get();
                moduleDelcarations.preprend(d);
            }
            moduleDelcarations.sort();

            // Generate .sth header
            ASTWriter writer;
            writer.visit(&moduleDelcarations);

            // Duplicated header lines are removed
            return new CompilerModule(name, moduleCode, removeDuplicatedLines(writer.getSourceCode()));
        }
    }

} // namespace stark