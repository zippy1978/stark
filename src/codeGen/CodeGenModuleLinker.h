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
        std::vector<CodeGenContext *> contexts;

        /* Destination llvm module */
        Module *module;

        LLVMContext llvmContext;

    public:
        CodeGenModuleLinker(std::string name) : name(name) {module = new Module(name, llvmContext);}
        void addContext(CodeGenContext *context) { contexts.push_back(context); }
        void link();
        void writeCode(std::string filename);
    };

} // namespace stark

#endif