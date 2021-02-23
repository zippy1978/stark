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

        Logger logger;

    public:
        CompilerModule(std::string name) : name(name) {}
        CompilerModule(std::string name, CodeGenBitcode *bitcode, std::string headerCode) : name(name), bitcode(bitcode), headerCode(headerCode) {}
        std::string getHeaderCode() { return headerCode; }
        std::unique_ptr<CodeGenBitcode> getBitcode() { return std::move(bitcode); }
        std::string getName() { return name; }

        /** Write module to the given file name (or directory name if it has a header). */
        void write(std::string filename);

        /** Load module from a file name or directory name. */
        void load(std::string filename);
    };

} // namespace stark

#endif