#ifndef CODEGEN_CODEGENLINKER_H
#define CODEGEN_CODEGENLINKER_H

#include "CodeGenContext.h"

using namespace llvm;

namespace stark
{
    /**
     * Link different CodeGenContext into a single stark module.
     */
    class CodeGenModuleLinker
    {

        /* Module name */
        std::string name = nullptr;

        /* List of contexts to link */
        std::vector<std::unique_ptr<CodeGenContext>> contexts;

        /* Destination llvm module */
        Module *llvmModule;

        LLVMContext llvmContext;

        /** Display debug logs if enabled */
        bool debugEnabled = false;

    public:
        CodeGenModuleLinker(std::string name) : name(name) { llvmModule = new Module(name, llvmContext); }
        void addContext(CodeGenContext *context) { contexts.push_back(std::unique_ptr<CodeGenContext>(context)); }
        void setDebugEnabled(bool d) { debugEnabled = d; }
        void link();
        void writeCode(std::string filename);
    };

} // namespace stark

#endif