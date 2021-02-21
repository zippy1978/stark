#ifndef COMPILER_COMPILERMODULE_H
#define COMPILER_COMPILERMODULE_H

#include <iostream>
#include <map>
#include <vector>

#include "../util/Util.h"
#include "../ast/AST.h"
#include "../codeGen/CodeGen.h"

namespace stark
{
    /**
     * Represents a strak module.
     */
    class CompilerModule
    {
        std::string name;

        /** Module bitcode */
        std::unique_ptr<CodeGenBitcode> bitcode;

        /** Module header declarations of the module as stark source code */
        std::string headerCode = "";

    public:
        CompilerModule(std::string name) : name(name) {}
        CompilerModule(std::string name, CodeGenBitcode *bitcode, std::string headerCode) : name(name), bitcode(bitcode), headerCode(headerCode) {}

        /** Write module to the given file name (or directory name if it has a header). */
        void write(std::string filename);
    };

} // namespace stark

#endif