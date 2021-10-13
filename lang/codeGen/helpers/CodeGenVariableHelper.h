#ifndef CODEGEN_CODEGENVARIABLEHELPER_H
#define CODEGEN_CODEGENVARIABLEHELPER_H

#include <llvm/IR/Type.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/BasicBlock.h>

#include "../../ast/AST.h"
#include "../CodeGenVariable.h"

using namespace llvm;

namespace stark
{
    class CodeGenFileContext;

    /**
     * Variable helper.
     * Helper functions for variables handling.
     */
    class CodeGenVariableHelper
    {

        CodeGenFileContext *context;

    public:
        CodeGenVariableHelper(CodeGenFileContext *context) : context(context) {}

        /**
         * Creates a variable from an AST variable declaration.
         */
        CodeGenVariable *createVariable(ASTVariableDeclaration *variableDeclaration);

        /**
         * Creates a default value for a given variable.
         */
        Value *createDefaultValue(CodeGenVariable *variable);
    };

} // namespace stark

#endif