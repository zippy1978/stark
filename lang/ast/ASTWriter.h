#ifndef AST_ASTWRITER_H
#define AST_ASTWRITER_H

#include <sstream>

#include "../ast/AST.h"

namespace stark
{

  /**
   * AST writer.
   * An AST visitor used to generate source code back from AST.
   */
  class ASTWriter : public ASTVisitor
  {
    std::ostringstream output;

  public:
    void visit(ASTInteger *node);
    void visit(ASTBoolean *node);
    void visit(ASTDouble *node);
    void visit(ASTIdentifier *node);
    void visit(ASTString *node);
    void visit(ASTBlock *node);
    void visit(ASTAssignment *node);
    void visit(ASTExpressionStatement *node);
    void visit(ASTVariableDeclaration *node);
    void visit(ASTFunctionSignature *node);
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
    void visit(ASTNull *node);
    std::string getSourceCode() { return output.str(); }
  };

} // namespace stark

#endif