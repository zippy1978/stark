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
    /**
     * Delcaratin block generated by the extractor.
     */
    std::unique_ptr<ASTBlock> declarationBlock;

    /**
     * Processed module name
     */
    std::string moduleName = "main";

    /**
     * Target module name.
     * The module name for which declarations ar extracted.
     */
    std::string targetModuleName = "main";

    /**
     * Builtin type names that must never be prefixed.
     */
    std::vector<std::string> builtinTypeNames;

  private:
    /**
     * Checks if a type identifier belongs to the current module
     */
    bool isModuleType(ASTIdentifier *typeId);

    /**
     * Checks if the type identifier should be prefixed by the module name during extraftion.
     */
    bool shouldPrefix(ASTIdentifier *typeId);

    /**
     * Process variable list etraction.
     */
    ASTVariableList extractVariableList(ASTVariableList list);

    /**
     * Extract type.
     * Return a new type identifier for ectraction
     */
    ASTIdentifier *extractType(ASTIdentifier *typeId);

  public:
    ASTDeclarationExtractor(std::string targetModuleName) : targetModuleName(targetModuleName)
    {
      declarationBlock = std::make_unique<ASTBlock>();
      builtinTypeNames.push_back("int");
      builtinTypeNames.push_back("double");
      builtinTypeNames.push_back("bool");
      builtinTypeNames.push_back("string");
      builtinTypeNames.push_back("void");
      builtinTypeNames.push_back("any");
    }
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
    void visit(ASTAnonymousFunction *node);
    void visit(ASTFunctionCall *node);
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
    ASTBlock *getDeclarationBlock() { return declarationBlock.get(); }
  };

} // namespace stark

#endif