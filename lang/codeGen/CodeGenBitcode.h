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

        /** 
         * Compile and writes object code to file for the given target
         */
        void writeObjectCode(std::string filename, std::string targetString);

        /** 
         * Compile and writes object code to file (uses host system as target)
         */
        void writeObjectCode(std::string filename);

        Module *getLlvmModule() { return llvmModule; }

        /**
         * Return host target triple.
         */
        static std::string getHostTargetTriple();
    };

} // namespace stark

#endif