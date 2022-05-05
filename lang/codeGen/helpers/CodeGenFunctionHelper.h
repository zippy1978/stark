#ifndef CODEGEN_CODEGENFUNCTIONHELPER_H
#define CODEGEN_CODEGENFUNCTIONHELPER_H

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
     * Function helper.
     * Helper functions for function handling.
     */
    class CodeGenFunctionHelper
    {

        CodeGenFileContext *context;

    public:
        CodeGenFunctionHelper(CodeGenFileContext *context) : context(context) {}

        /**
         * Creates function type from a signature.
         */
        FunctionType *createFunctionType(ASTFunctionSignature *signature);

        /**
         * Creates a function declaration.
         */
        Function *createFunctionDeclaration(ASTFunctionDeclaration *functionDeclaration);

        /**
         * Validates names of a function declaration AST node.
         * If successfull, returns a ready to use (mangled if necessary) function name.
         **/
        std::string checkAndGenerateMangledFunctionName(ASTFunctionDeclaration *functionDeclaration);

        /**
         * Generate a LLVM compliant type name for a function signature.
         */
        std::string generateFunctionTypeName(ASTFunctionSignature *signature);

        /**
         * Creates a vector of argument types from a ASTVariableList.
         */
        std::vector<Type *> checkAndExtractArgumentTypes(ASTVariableList arguments);

        /**
         * Creates a function return type from an AST function declaration.
         * If id is null, a void type will be created.
         */
        Type *getReturnType(ASTFunctionDeclaration *functionDeclaration);

        /**
         * Expands main functions arguments as local variables on a block.
         */
        void expandMainArgs(Function *function, std::string mainArgsParameterName, BasicBlock *block);

        /**
         * Expands function arguments as local variabes on a block.
         */
        void expandLocalVariables(Function *function, ASTVariableList arguments, BasicBlock *block);

        /**
         * Checks if the function name with the provides argument types is the main funvtion with arguments.
         */
        bool isMainFunctionWithArgs(std::string functionName, std::vector<Type *> argumentTypes);

        /**
         * Returns main function arguments types (argc and argv).
         */
        std::vector<Type *> getMainArgumentTypes();

        /**
         * Creates return instruction on the provided block.
         */
        void createReturn(Function *function, Value* value, BasicBlock *block);

        /**
         * Creates an environment structure for a closure, given a list of local variables.
         * Structure members are declared in the same order as the input variable list.
         */
        StructType *createClosureEnvironment(std::vector<CodeGenVariable *> variables);

    };

} // namespace stark

#endif