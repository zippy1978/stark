#ifndef CODEGEN_CODEGENTYPEHELPER_H
#define CODEGEN_CODEGENTYPEHELPER_H

#include <llvm/IR/Type.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/BasicBlock.h>

#include "../../ast/AST.h"

using namespace llvm;

namespace stark
{
    class CodeGenFileContext;

    /**
     * Type helper.
     * Helper functions for types handling.
     */
    class CodeGenTypeHelper
    {

        CodeGenFileContext *context;

    public:
        CodeGenTypeHelper(CodeGenFileContext *context) : context(context) {}

        /**
         * Return  llvm type from AST identifier
         */
        Type* getType(ASTIdentifier *id);

        /**
         * Return  llvm type from AST signature
         */
        Type* getType(ASTFunctionSignature *functionSignature);

    };

} // namespace stark

#endif