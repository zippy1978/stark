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
        CodeGenChecker(CodeGenFileContext *context): context(context) {}
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