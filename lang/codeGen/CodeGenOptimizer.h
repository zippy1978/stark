#ifndef CODEGEN_CODEGENOPTIMIZER_H
#define CODEGEN_CODEGENOPTIMIZER_H

using namespace llvm;

#include "../util/Util.h"
#include "CodeGenBitcode.h"

namespace stark
{
    /**
     * Handles bitcode optimization.
     */
    class CodeGenOptimizer
    {
        Logger logger;

        bool debugEnabled = false;

    public:
        CodeGenOptimizer() {}

        /** Optimizes bitcode. */
        void optimize(CodeGenBitcode *bitcode);
        void setDebugEnabled(bool d) { debugEnabled = d; }
    };

} // namespace stark

#endif