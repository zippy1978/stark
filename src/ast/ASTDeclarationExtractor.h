#ifndef AST_ASTDECLARATIONEXTRACTOR_H
#define AST_ASTDECLARATIONEXTRACTOR_H

#include "../ast/AST.h"

namespace stark
{

  /**
   * Declaration AST visitor.
   * Visit an AST abd add function and type declarations to a new (output) block.
   */
  class ASTDeclarationExtractor : public ASTVisitor
  {
    std::unique_ptr<ASTBlock> declarationBlock;
    std::string moduleName = "main";

  public:
    ASTDeclarationExtractor() { declarationBlock = std::make_unique<ASTBlock>(); }
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
    void visit(ASTModuleDeclaration *node);
    void visit(ASTImportDeclaration *node);
    ASTBlock *getDeclarationBlock() { return declarationBlock.get(); }
  };

} // namespace stark

#endif