#ifndef CODEGEN_CODEGENCHECKER_H
#define CODEGEN_CODEGENCHECKER_H

#include <vector>

namespace stark
{
    class CodeGenFileContext;

    /**
     * Code checker.
     * In charge of checking that code generation combinations are allowed.
     * If not allowed : log a (fatal) error with the context logger
     */
    class CodeGenChecker
    {
        CodeGenFileContext *context;

    public:
        CodeGenChecker(CodeGenFileContext *context) : context(context) {}
        void checkNoMemberIdentifier(ASTIdentifier *id);
        void checkTypeIdentifier(ASTIdentifier *typeId);
        void checkModuleIdentifier(ASTIdentifier *moduleId);
        void checkAllowedVariableDeclaration(ASTIdentifier *variableId);
        void checkAvailableLocalVariable(ASTIdentifier *variableId);
        void checkAllowedTypeDeclaration(ASTIdentifier *typeId);
        void checkAllowedFunctionDeclaration(ASTIdentifier *functionId);
        void checkAllowedFunctionCall(ASTIdentifier *functionId, Function *function, std::vector<Value *> args);
        void checkVariableAssignment(ASTIdentifier *variableId, Value *variable, Value *value);
        void checkAllowedModuleDeclaration(ASTIdentifier *moduleId);
        /**
         * Tests if a given LLVM value is a null (constant).
         */
        bool isNull(Value *value);
        /**
         * Tests if a value can be assign to a type.
         */
        bool canAssign(Value *value, std::string typeName);
    };

} // namespace stark

#endif