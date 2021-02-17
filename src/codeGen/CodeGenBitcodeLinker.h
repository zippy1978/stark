#ifndef CODEGEN_CODEGENBITCODELINKER_H
#define CODEGEN_CODEGENBITCODELINKER_H

#include "CodeGenBitcode.h"
#include "CodeGenContext.h"

using namespace llvm;

namespace stark
{
    /**
     * Link different CodeGenContext into a single stark module.
     */
    class CodeGenBitcodeLinker
    {

        /* Module name */
        std::string name;

        /* List of contexts to link */
        std::vector<std::unique_ptr<CodeGenBitcode>> bitcodes;

        /* Destination module */
        Module *llvmModule;

        LLVMContext llvmContext;

        /** Display debug logs if enabled */
        bool debugEnabled = false;

    public:
        CodeGenBitcodeLinker(std::string name) : name(name) { llvmModule = new Module(name, llvmContext); }
        void addBitcode(std::unique_ptr<CodeGenBitcode> c) { bitcodes.push_back(std::move(c)); }
        void setDebugEnabled(bool d) { debugEnabled = d; }
        CodeGenBitcode *link();
    };

} // namespace stark

#endif