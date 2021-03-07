#ifndef CODEGEN_CODEGENBITCODE_H
#define CODEGEN_CODEGENBITCODE_H

using namespace llvm;

#include "../util/Util.h"

namespace stark
{
    /**
     * Holds generated bitcode data.
     */
    class CodeGenBitcode
    {
        Module *llvmModule;

        LLVMContext context;

        Logger logger;

    public:
        CodeGenBitcode(Module *llvmModule) : llvmModule(llvmModule) {}
        /** Loads bitcode from file. */
        void load(std::string filename);

        /** Writes bitcode to file. */
        void write(std::string filename);

        Module *getLlvmModule() { return llvmModule; }
    };

} // namespace stark

#endif