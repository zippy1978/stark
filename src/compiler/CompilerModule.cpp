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
    void CompilerModule::compile(std::string filename)
    {
        CodeGenModuleLinker linker(this->name);

        // Load and parse runtime declarations
        StarkParser parser("runtime");
        ASTBlock *declarations = parser.parse(Runtime::getDeclarations());

        // TODO : get module header to inject it as well

        for (auto it = sourceFiles.begin(); it != sourceFiles.end(); it++)
        {
            std::string filename = *it;

            // Read input file
            std::ifstream input(filename);
            if (!input)
            {
                logger.logError(format("Cannot open input file: %s", filename.c_str()));
            }

            // Parse sources
            StarkParser parser(filename);
            ASTBlock *program = parser.parse(&input);

            // Prepend runtime declarations
            program->preprend(declarations);

            // Generate IR
            CodeGenContext *context = new CodeGenContext(filename);
            context->setDebugEnabled(debugEnabled);
            context->generateCode(*program);

            // Add to linker
            linker.addContext(context);
        }

        // Link generated code
        linker.link();
    }

} // namespace stark