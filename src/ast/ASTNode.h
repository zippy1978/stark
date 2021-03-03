#ifndef AST_ASTNODE_H
#define AST_ASTNODE_H

#include <iostream>
#include <vector>
#include <memory>

#include "../util/Util.h"

namespace stark
{

  class ASTVisitor;
  class ASTStatement;
  class ASTExpression;
  class ASTVariableDeclaration;
  class ASTIdentifier;

  typedef std::vector<ASTStatement *> ASTStatementList;
  typedef std::vector<ASTExpression *> ASTExpressionList;
  typedef std::vector<ASTVariableDeclaration *> ASTVariableList;
  typedef std::vector<ASTIdentifier *> ASTIdentifierList;

  ASTStatementList cloneList(ASTStatementList list);
  void deleteList(ASTStatementList list);
  ASTVariableList cloneList(ASTVariableList list);
  void deleteList(ASTVariableList list);
  ASTExpressionList cloneList(ASTExpressionList list);
  void deleteList(ASTExpressionList list);

  enum ASTBinaryOperator
  {
    AND,
    OR,
    ADD,
    SUB,
    MUL,
    DIV
  };

  enum ASTComparisonOperator
  {
    EQ,
    NE,
    LT,
    LE,
    GT,
    GE
  };

  class ASTNode
  {
  public:
    FileLocation location;
    virtual ~ASTNode() {}
    virtual void accept(ASTVisitor *visitor) = 0;
  };

  class ASTExpression : public ASTNode
  {
  public:
    virtual ~ASTExpression() {}
    virtual ASTExpression *clone() = 0;
  };

  class ASTStatement : public ASTNode
  {
  public:
    virtual ~ASTStatement() {}
    virtual ASTStatement *clone() = 0;
    /**
     * Defines order priority in a source file.
     * Used when sorting blocks.
     * The lowest value is the higher priority.
     * */
    virtual int getPriority() { return 10; }
  };

  class ASTInteger : public ASTExpression
  {
    long long value;

  public:
    ASTInteger(long long value) : value(value) {}
    long long getValue() { return value; }
    void accept(ASTVisitor *visitor);
    ASTInteger *clone();
  };

  class ASTBoolean : public ASTExpression
  {
    bool value;

  public:
    ASTBoolean(bool value) : value(value) {}
    bool getValue() { return value; }
    void accept(ASTVisitor *visitor);
    ASTBoolean *clone();
  };

  class ASTDouble : public ASTExpression
  {
    double value;

  public:
    ASTDouble(double value) : value(value) {}
    double getValue() { return value; }
    void accept(ASTVisitor *visitor);
    ASTDouble *clone();
  };

  class ASTString : public ASTExpression
  {
    std::string value;

  public:
    ASTString(std::string value) : value(value) {}
    std::string getValue() { return value; }
    void accept(ASTVisitor *visitor);
    ASTString *clone();
  };

  class ASTNull : public ASTExpression
  {
  public:
    void accept(ASTVisitor *visitor);
    ASTNull *clone();
  };

  class ASTArray : public ASTExpression
  {
    ASTExpressionList arguments;

  public:
    ASTArray(ASTExpressionList &arguments) : arguments(arguments) {}
    ~ASTArray();
    ASTExpressionList getArguments() { return arguments; }
    void accept(ASTVisitor *visitor);
    ASTArray *clone();
  };

  class ASTIdentifier : public ASTExpression
  {
    std::string name;
    std::unique_ptr<ASTIdentifier> member;
    std::unique_ptr<ASTExpression> index;

    /** Indicates it is an array in case of usage in a delcaration */
    bool array = false;

  public:
    ASTIdentifier(std::string name, ASTExpression *index, ASTIdentifierList *members);
    std::string getName() { return name; }
    ASTIdentifier *getMember() { return member.get(); }
    ASTExpression *getIndex() { return index.get(); }
    void setIndex(ASTExpression *i) { index = std::unique_ptr<ASTExpression>(i); }
    bool isArray() { return array; }
    void setArray(bool a) { array = a; }
    /** Returns the count of nested members */
    int countNestedMembers();
    /** Gets the identifier fullname, for example id.member.submember... */
    std::string getFullName();
    void accept(ASTVisitor *visitor);
    ASTIdentifier *clone();
  };

  class ASTBlock : public ASTExpression
  {
    ASTStatementList statements;

  public:
    ~ASTBlock();
    ASTStatementList getStatements() { return statements; }
    void addStatement(ASTStatement *s) { statements.push_back(s); }
    ASTBlock *clone();
    /**
     * Sort statments of a block.
     * Sort order is : types, then functions, then the rest.
     * */
    void sort();
    /** 
     * Prepend statements of a block to the current block.
     * If the first statement of the target (this) block is a module declaration :
     * then statements are inserted right after it.
     * */
    void preprend(ASTBlock *block);
    void accept(ASTVisitor *visitor);
  };

  class ASTAssignment : public ASTExpression
  {
    std::unique_ptr<ASTIdentifier> lhs;
    std::unique_ptr<ASTExpression> rhs;

  public:
    ASTAssignment(ASTIdentifier *lhs, ASTExpression *rhs) : lhs(lhs), rhs(rhs) {}
    ASTIdentifier *getLhs() { return lhs.get(); }
    ASTExpression *getRhs() { return rhs.get(); }
    void accept(ASTVisitor *visitor);
    ASTAssignment *clone();
  };

  class ASTExpressionStatement : public ASTStatement
  {
    std::unique_ptr<ASTExpression> expression;

  public:
    ASTExpressionStatement(ASTExpression *expression) : expression(expression) {}
    ASTExpression *getExpression() { return expression.get(); }
    void accept(ASTVisitor *visitor);
    ASTExpressionStatement *clone();
  };

  class ASTVariableDeclaration : public ASTStatement
  {
    std::unique_ptr<ASTIdentifier> type;
    std::unique_ptr<ASTIdentifier> id;
    std::unique_ptr<ASTExpression> assignmentExpr;
    bool array;

  public:
    ASTVariableDeclaration(ASTIdentifier *type, ASTIdentifier *id, bool array, ASTExpression *assignmentExpr) : type(type), id(id), array(array), assignmentExpr(assignmentExpr) {}
    ASTIdentifier *getType() { return type.get(); }
    ASTIdentifier *getId() { return id.get(); }
    ASTExpression *getAssignmentExpr() { return assignmentExpr.get(); }
    bool isArray() { return array; }
    void accept(ASTVisitor *visitor);
    ASTVariableDeclaration *clone();
  };

  class ASTFunctionDefinition : public ASTStatement
  {
    std::unique_ptr<ASTIdentifier> type;
    std::unique_ptr<ASTIdentifier> id;
    std::unique_ptr<ASTBlock> block;
    ASTVariableList arguments;

  public:
    ASTFunctionDefinition(ASTIdentifier *type, ASTIdentifier *id, ASTVariableList &arguments, ASTBlock *block) : type(type), id(id), arguments(arguments), block(block) {}
    ~ASTFunctionDefinition();
    ASTIdentifier *getType() { return type.get(); }
    ASTIdentifier *getId() { return id.get(); }
    ASTVariableList getArguments() { return arguments; }
    ASTBlock *getBlock() { return block.get(); }
    void accept(ASTVisitor *visitor);
    ASTFunctionDefinition *clone();
  };

  class ASTFunctionCall : public ASTExpression
  {
    std::unique_ptr<ASTIdentifier> id;
    ASTExpressionList arguments;

  public:
    ASTFunctionCall(ASTIdentifier *id, ASTExpressionList &arguments) : id(id), arguments(arguments) {}
    ASTFunctionCall(ASTIdentifier *id) : id(id) {}
    ~ASTFunctionCall();
    ASTIdentifier *getId() { return id.get(); }
    ASTExpressionList getArguments() { return arguments; }
    void accept(ASTVisitor *visitor);
    ASTFunctionCall *clone();
  };

  class ASTExternDeclaration : public ASTStatement
  {
    std::unique_ptr<ASTIdentifier> type;
    std::unique_ptr<ASTIdentifier> id;
    ASTVariableList arguments;

  public:
    ASTExternDeclaration(ASTIdentifier *type, ASTIdentifier *id, ASTVariableList &arguments) : type(type), id(id), arguments(arguments) {}
    ~ASTExternDeclaration()
    {
      for (int i = 0; i < arguments.size(); i++)
      {
        delete arguments[i];
      }
    }
    ASTIdentifier *getType() { return type.get(); }
    ASTIdentifier *getId() { return id.get(); }
    ASTVariableList getArguments() { return arguments; }
    void accept(ASTVisitor *visitor);
    ASTExternDeclaration *clone();
    int getPriority() { return 2; }
  };

  class ASTFunctionDeclaration : public ASTStatement
  {
    std::unique_ptr<ASTIdentifier> type;
    std::unique_ptr<ASTIdentifier> id;
    ASTVariableList arguments;

  public:
    ASTFunctionDeclaration(ASTIdentifier *type, ASTIdentifier *id, ASTVariableList &arguments) : type(type), id(id), arguments(arguments) {}
    ~ASTFunctionDeclaration();
    ASTIdentifier *getType() { return type.get(); }
    ASTIdentifier *getId() { return id.get(); }
    ASTVariableList getArguments() { return arguments; }
    void accept(ASTVisitor *visitor);
    ASTFunctionDeclaration *clone();
    int getPriority() { return 3; }
  };

  class ASTReturnStatement : public ASTStatement
  {
    std::unique_ptr<ASTExpression> expression;

  public:
    ASTReturnStatement(ASTExpression *expression) : expression(expression) {}
    ASTExpression *getExpression() { return expression.get(); }
    void accept(ASTVisitor *visitor);
    ASTReturnStatement *clone();
  };

  class ASTBinaryOperation : public ASTExpression
  {
    ASTBinaryOperator op;
    std::unique_ptr<ASTExpression> lhs;
    std::unique_ptr<ASTExpression> rhs;

  public:
    ASTBinaryOperation(ASTExpression *lhs, ASTBinaryOperator op, ASTExpression *rhs) : lhs(lhs), op(op), rhs(rhs) {}
    ASTExpression *getLhs() { return lhs.get(); }
    ASTExpression *getRhs() { return rhs.get(); }
    ASTBinaryOperator getOp() { return op; }
    void accept(ASTVisitor *visitor);
    ASTBinaryOperation *clone();
  };

  class ASTComparison : public ASTExpression
  {
    ASTComparisonOperator op;
    std::unique_ptr<ASTExpression> lhs;
    std::unique_ptr<ASTExpression> rhs;

  public:
    ASTComparison(ASTExpression *lhs, ASTComparisonOperator op, ASTExpression *rhs) : lhs(lhs), op(op), rhs(rhs) {}
    ASTExpression *getLhs() { return lhs.get(); }
    ASTExpression *getRhs() { return rhs.get(); }
    ASTComparisonOperator getOp() { return op; }
    void accept(ASTVisitor *visitor);
    ASTComparison *clone();
  };

  class ASTIfElseStatement : public ASTStatement
  {
    std::unique_ptr<ASTExpression> condition;
    std::unique_ptr<ASTBlock> trueBlock;
    std::unique_ptr<ASTBlock> falseBlock;

  public:
    ASTIfElseStatement(ASTExpression *condition, ASTBlock *trueBlock, ASTBlock *falseBlock) : condition(condition), trueBlock(trueBlock), falseBlock(falseBlock) {}
    ASTExpression *getCondition() { return condition.get(); }
    ASTBlock *getTrueBlock() { return trueBlock.get(); }
    ASTBlock *getFalseBlock() { return falseBlock.get(); }
    void accept(ASTVisitor *visitor);
    ASTIfElseStatement *clone();
  };

  class ASTWhileStatement : public ASTStatement
  {
    std::unique_ptr<ASTExpression> condition;
    std::unique_ptr<ASTBlock> block;

  public:
    ASTWhileStatement(ASTExpression *condition, ASTBlock *block) : condition(condition), block(block) {}
    ASTExpression *getCondition() { return condition.get(); }
    ASTBlock *getBlock() { return block.get(); }
    void accept(ASTVisitor *visitor);
    ASTWhileStatement *clone();
  };

  class ASTStructDeclaration : public ASTStatement
  {
    std::unique_ptr<ASTIdentifier> id;
    ASTVariableList arguments;

  public:
    ASTStructDeclaration(ASTIdentifier *id, const ASTVariableList &arguments) : id(id), arguments(arguments) {}
    ~ASTStructDeclaration();
    ASTIdentifier *getId() { return id.get(); }
    ASTVariableList getArguments() { return arguments; }
    void accept(ASTVisitor *visitor);
    ASTStructDeclaration *clone();
    int getPriority() { return 1; }
  };

  class ASTTypeConversion : public ASTExpression
  {
    std::unique_ptr<ASTExpression> expression;
    std::unique_ptr<ASTIdentifier> type;

  public:
    ASTTypeConversion(ASTExpression *expression, ASTIdentifier *type) : expression(expression), type(type) {}
    ASTExpression *getExpression() { return expression.get(); }
    ASTIdentifier *getType() { return type.get(); }
    void accept(ASTVisitor *visitor);
    ASTTypeConversion *clone();
  };

  class ASTModuleDeclaration : public ASTStatement
  {
    std::unique_ptr<ASTIdentifier> id;

  public:
    ASTModuleDeclaration(ASTIdentifier *id) : id(id) {}
    ASTIdentifier *getId() { return id.get(); }
    void accept(ASTVisitor *visitor);
    ASTModuleDeclaration *clone();
    int getPriority() { return 0; }
  };

  class ASTImportDeclaration : public ASTStatement
  {
    std::unique_ptr<ASTIdentifier> id;

  public:
    ASTImportDeclaration(ASTIdentifier *id) : id(id) {}
    ASTIdentifier *getId() { return id.get(); }
    void accept(ASTVisitor *visitor);
    ASTImportDeclaration *clone();
    int getPriority() { return 0; }
  };

  /*
 * Virtual class to visit the AST.
 */
  class ASTVisitor
  {
  public:
    virtual void visit(ASTInteger *node) = 0;
    virtual void visit(ASTBoolean *node) = 0;
    virtual void visit(ASTDouble *node) = 0;
    virtual void visit(ASTString *node) = 0;
    virtual void visit(ASTIdentifier *node) = 0;
    virtual void visit(ASTBlock *node) = 0;
    virtual void visit(ASTAssignment *node) = 0;
    virtual void visit(ASTExpressionStatement *node) = 0;
    virtual void visit(ASTVariableDeclaration *node) = 0;
    virtual void visit(ASTFunctionDefinition *node) = 0;
    virtual void visit(ASTFunctionCall *node) = 0;
    virtual void visit(ASTExternDeclaration *node) = 0;
    virtual void visit(ASTReturnStatement *node) = 0;
    virtual void visit(ASTBinaryOperation *node) = 0;
    virtual void visit(ASTComparison *node) = 0;
    virtual void visit(ASTIfElseStatement *node) = 0;
    virtual void visit(ASTWhileStatement *node) = 0;
    virtual void visit(ASTStructDeclaration *node) = 0;
    virtual void visit(ASTArray *node) = 0;
    virtual void visit(ASTTypeConversion *node) = 0;
    virtual void visit(ASTFunctionDeclaration *node) = 0;
    virtual void visit(ASTModuleDeclaration *node) = 0;
    virtual void visit(ASTImportDeclaration *node) = 0;
    virtual void visit(ASTNull *node) = 0;
  };

} // namespace stark

#endif