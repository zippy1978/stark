#ifndef CODEGEN_CODEGENIDENTIFIERRESOLVER_H
#define CODEGEN_CODEGENIDENTIFIERRESOLVER_H

#include <llvm/IR/Type.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/BasicBlock.h>

#include "../ast/AST.h"

using namespace llvm;

namespace stark
{
    class CodeGenFileContext;

    /**
     * Identifier resolver.
     * In charge of resolving ASTIdentifiers
     */
    class CodeGenIdentifierResolver
    {

        CodeGenFileContext *context;

    public:
        CodeGenIdentifierResolver(CodeGenFileContext *context) : context(context) {}
        /** 
         * Resolve LLVM function forn an identifier.
         * If not funciton found, return null.
         */
        Function *resolveFunction(ASTIdentifier *id);
    };

} // namespace stark

#endif