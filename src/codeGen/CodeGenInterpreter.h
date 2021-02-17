#ifndef CODEGEN_CODEGENINTERPRETER_H
#define CODEGEN_CODEGENINTERPRETER_H

#include "CodeGenBitcode.h"
#include "CodeGenFileContext.h"

using namespace llvm;

namespace stark
{
    /**
     * Executes bitcode.
     */
    class CodeGenInterpreter
    {
        Logger logger;

    public:
        /** Executes the provided bitcode
         * argc and argv are passed as a main function.
         * Return is the main function return value.
         * */
        int run(CodeGenBitcode *code, int argc, char *argv[]);
    };

} // namespace stark

#endif