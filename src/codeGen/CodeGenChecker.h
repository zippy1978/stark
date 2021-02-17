#ifndef CODEGEN_CODEGENCHECKER_H
#define CODEGEN_CODEGENCHECKER_H

#include <vector>

namespace stark
{
    class CodeGenContext;

    /**
     * Code checker.
     * In charge of checking that code generation combinations are allowed.
     * If not allowed : log a (fatal) error with the context logger
     */
    class CodeGenChecker
    {
        CodeGenContext *context;    

    public:
        CodeGenChecker(CodeGenContext *context): context(context) {}
        void checkNoMemberIdentifier(ASTIdentifier *variableId);
        void checkAllowedVariableDeclaration(ASTIdentifier *variableId);
        void checkAvailableLocalVariable(ASTIdentifier *variableId);
        void checkAllowedTypeDeclaration(ASTIdentifier *typeId);
        void checkAllowedFunctionDeclaration(ASTIdentifier *functionId);
        void checkAllowedFunctionCall(ASTIdentifier *functionId, Function *function, std::vector<Value *> args);
        void checkVariableAssignment(ASTIdentifier *variableId, Value *variable, Value *value);
        void checkAllowedModuleDeclaration(ASTIdentifier *moduleId);
    };

} // namespace stark

#endif