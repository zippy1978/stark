#ifndef CODEGEN_CODEGENVISITOR_H
#define CODEGEN_CODEGENVISITOR_H

#include "CodeGenContext.h"

namespace stark
{

  /**
   * Code generation AST visitor.
   * Generates llvm code for every AST node.
   */
  class CodeGenVisitor : public ASTVisitor
  {
    CodeGenContext *context;

  private:
    /**
     * Generic external function declaration.
     */
    Function* createExternalDeclaration(std::string functionName, ASTVariableList arguments, ASTIdentifier *type);

  public:
    CodeGenVisitor(CodeGenContext *context) : context(context) {}
    Value *result;
    void visit(ASTInteger *node);
    void visit(ASTBoolean *node);
    void visit(ASTDouble *node);
    void visit(ASTIdentifier *node);
    void visit(ASTString *node);
    void visit(ASTBlock *node);
    void visit(ASTAssignment *node);
    void visit(ASTExpressionStatement *node);
    void visit(ASTVariableDeclaration *node);
    void visit(ASTFunctionDefinition *node);
    void visit(ASTFunctionCall *node);
    void visit(ASTExternDeclaration *node);
    void visit(ASTReturnStatement *node);
    void visit(ASTBinaryOperation *node);
    void visit(ASTComparison *node);
    void visit(ASTIfElseStatement *node);
    void visit(ASTWhileStatement *node);
    void visit(ASTStructDeclaration *node);
    void visit(ASTArray *node);
    void visit(ASTTypeConversion *node);
    void visit(ASTFunctionDeclaration *node);

  };

} // namespace stark

#endif