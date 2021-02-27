#ifndef INTERPRETER_NEWINTERPRETER_H
#define INTERPRETER_NEWINTERPRETER_H

#include "../codeGen/CodeGen.h"

using namespace llvm;

namespace stark
{
    /**
     * Executes bitcode.
     */
    class NewInterpreter
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