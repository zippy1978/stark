
#include "ast.hh"


class CodeGenVisitor: public ASTVisitor
{
    void visit(ASTExpression *node);
    void visit(ASTStatement *node);
    void visit(ASTInteger *node);
    void visit(ASTDouble *node);
    void visit(ASTIdentifier *node);
    void visit(ASTBlock *node);
    void visit(ASTAssignment *node);
    void visit(ASTExpressionStatement *node);
    void visit(ASTVariableDeclaration *node);
    void visit(ASTFunctionDeclaration *node);
    void visit(ASTMethodCall *node);
};