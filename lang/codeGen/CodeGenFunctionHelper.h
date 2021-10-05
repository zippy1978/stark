#ifndef CODEGEN_CODEGENFUNCTIONHELPER_H
#define CODEGEN_CODEGENFUNCTIONHELPER_H

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
    class CodeGenFunctionHelper
    {

        CodeGenFileContext *context;

    public:
        CodeGenFunctionHelper(CodeGenFileContext *context) : context(context) {}

        /**
         * Create function type from a signature.
         */
        FunctionType *createFunctionType(ASTFunctionSignature *signature);

        /**
         * Create a function declaration.
         */
        Function *createExternalDeclaration(std::string functionName, ASTVariableList arguments, ASTIdentifier *type);

        /**
         * Create a vector of argument types from a ASTVariableList.
         */
        std::vector<Type *> checkAndExtractArgumentTypes(ASTVariableList arguments);

    };

} // namespace stark

#endif