#ifndef AST_ASTNODE_H
#define AST_ASTNODE_H

#include <iostream>
#include <vector>

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
  };

  class ASTStatement : public ASTNode
  {
  public:
    virtual ~ASTStatement() {}
  };

  class ASTInteger : public ASTExpression
  {
  public:
    long long value;
    ASTInteger(long long value) : value(value) {}
    ~ASTInteger()
    {
      std::cout << ">>>>>>>>>>>>> CLEAR ASTInteger " << std::endl;
    }
    void accept(ASTVisitor *visitor);
  };

  class ASTBoolean : public ASTExpression
  {
  public:
    bool value;
    ASTBoolean(bool value) : value(value) {}
    void accept(ASTVisitor *visitor);
  };

  class ASTDouble : public ASTExpression
  {
  public:
    double value;
    ASTDouble(double value) : value(value) {}
    void accept(ASTVisitor *visitor);
  };

  class ASTString : public ASTExpression
  {
  public:
    std::string value;
    ASTString(std::string value) : value(value) {}
    void accept(ASTVisitor *visitor);
  };

  class ASTArray : public ASTExpression
  {
  public:
    ASTExpressionList arguments;
    ASTArray(ASTExpressionList &arguments) : arguments(arguments) {}
    ~ASTArray()
    {
      std::cout << ">>>>>>>>>>>>> CLEAR ASTArray " << std::endl;
      arguments.clear();
    }
    void accept(ASTVisitor *visitor);
  };

  class ASTIdentifier : public ASTExpression
  {
  public:
    std::string name;
    ASTIdentifier *member = nullptr; // Nullable because not mandatory
    ASTExpression *index = nullptr;  // Index to handle varArray[index]
    bool array = false;              // Indicates it is an array in case of usage in a delcaration
    ASTIdentifier(std::string name, ASTExpression *index, ASTIdentifierList *members);
    ~ASTIdentifier()
    {
      std::cout << ">>>>>>>>>>>>> CLEAR ASTIdentifier " << std::endl;
      if (member)
        delete member;
      if (index)
        delete index;
    }
    /* Return the count of nested members */
    int countNestedMembers();
    /* Get the identifier fullname, for example id.member.submember... */
    std::string getFullName();
    void accept(ASTVisitor *visitor);
  };

  class ASTBlock : public ASTExpression
  {
  public:
    ASTStatementList statements;
    ASTBlock() {}
    ~ASTBlock()
    {
      std::cout << ">>>>>>>>>>>>> CLEAR ASTBlock " << std::endl;
      for (int i = 0; i < statements.size(); i++)
      {
        std::cout << " - " << typeid(statements[i]).name() << std::endl;
        delete statements[i];
      }
    }
    /* Prepend statements of a block to the current block */
    void preprend(ASTBlock *block)
    {
      statements.insert(statements.begin(), block->statements.begin(), block->statements.end());
    }
    void accept(ASTVisitor *visitor);
  };

  class ASTAssignment : public ASTExpression
  {
  public:
    ASTIdentifier &lhs;
    ASTExpression &rhs;
    ASTAssignment(ASTIdentifier &lhs, ASTExpression &rhs) : lhs(lhs), rhs(rhs) {}
    void accept(ASTVisitor *visitor);
  };

  class ASTExpressionStatement : public ASTStatement
  {
  public:
    ASTExpression &expression;
    ASTExpressionStatement(ASTExpression &expression) : expression(expression) {}
    void accept(ASTVisitor *visitor);
  };

  class ASTVariableDeclaration : public ASTStatement
  {
  public:
    ASTIdentifier &type;
    ASTIdentifier &id;
    ASTExpression *assignmentExpr = nullptr; // Pointer, because nullable
    bool isArray;
    ASTVariableDeclaration(ASTIdentifier &type, ASTIdentifier &id, bool isArray, ASTExpression *assignmentExpr) : type(type), id(id), isArray(isArray), assignmentExpr(assignmentExpr) {}
    ~ASTVariableDeclaration()
    {
      std::cout << ">>>>>>>>>>>>> CLEAR ASTVariableDeclaration " << id.name << std::endl;
      if (assignmentExpr)
        delete assignmentExpr;
    }
    void accept(ASTVisitor *visitor);
  };

  class ASTFunctionDefinition : public ASTStatement
  {
  public:
    ASTIdentifier &type;
    ASTIdentifier &id;
    ASTVariableList arguments;
    ASTBlock &block;
    ASTFunctionDefinition(ASTIdentifier &type, ASTIdentifier &id, ASTVariableList &arguments, ASTBlock &block) : type(type), id(id), arguments(arguments), block(block) {}
    ~ASTFunctionDefinition()
    {
      std::cout << ">>>>>>>>>>>>> CLEAR ASTFunctionDefinition " << std::endl;
      for (int i = 0; i < arguments.size(); i++)
      {
        delete arguments[i];
      }
    }
    void accept(ASTVisitor *visitor);
  };

  class ASTFunctionCall : public ASTExpression
  {
  public:
    ASTIdentifier &id;
    ASTExpressionList arguments;
    ASTFunctionCall(ASTIdentifier &id, ASTExpressionList &arguments) : id(id), arguments(arguments) {}
    ASTFunctionCall(ASTIdentifier &id) : id(id) {}
    ~ASTFunctionCall()
    {
      std::cout << ">>>>>>>>>>>>> CLEAR ASTFunctionCall " << std::endl;
      for (int i = 0; i < arguments.size(); i++)
      {
        delete arguments[i];
      }

    }
    void accept(ASTVisitor *visitor);
  };

  class ASTExternDeclaration : public ASTStatement
  {
  public:
    ASTIdentifier &type;
    ASTIdentifier &id;
    ASTVariableList arguments;
    ASTExternDeclaration(ASTIdentifier &type, ASTIdentifier &id, ASTVariableList &arguments) : type(type), id(id), arguments(arguments) {}
    ~ASTExternDeclaration()
    {
      std::cout << ">>>>>>>>>>>>> CLEAR ASTExternDeclaration " << std::endl;
      for (int i = 0; i < arguments.size(); i++)
      {
        delete arguments[i];
      }
    }
    void accept(ASTVisitor *visitor);
  };

  class ASTFunctionDeclaration : public ASTStatement
  {
  public:
    ASTIdentifier &type;
    ASTIdentifier &id;
    ASTVariableList arguments;
    ASTFunctionDeclaration(ASTIdentifier &type, ASTIdentifier &id, ASTVariableList &arguments) : type(type), id(id), arguments(arguments) {}
    ~ASTFunctionDeclaration()
    {
      std::cout << ">>>>>>>>>>>>> CLEAR ASTFunctionDeclaration " << std::endl;
      for (int i = 0; i < arguments.size(); i++)
      {
        delete arguments[i];
      }
    }
    void accept(ASTVisitor *visitor);
  };

  class ASTReturnStatement : public ASTStatement
  {
  public:
    ASTExpression &expression;
    ASTReturnStatement(ASTExpression &expression) : expression(expression) {}
    ~ASTReturnStatement() {
      std::cout << ">>>>>>>>>>>>> CLEAR ASTReturnStatement " << std::endl;
    }
    void accept(ASTVisitor *visitor);
  };

  class ASTBinaryOperation : public ASTExpression
  {
  public:
    ASTBinaryOperator op;
    ASTExpression &lhs;
    ASTExpression &rhs;
    ASTBinaryOperation(ASTExpression &lhs, ASTBinaryOperator op, ASTExpression &rhs) : lhs(lhs), op(op), rhs(rhs) {}
    void accept(ASTVisitor *visitor);
  };

  class ASTComparison : public ASTExpression
  {
  public:
    ASTComparisonOperator op;
    ASTExpression &lhs;
    ASTExpression &rhs;
    ASTComparison(ASTExpression &lhs, ASTComparisonOperator op, ASTExpression &rhs) : lhs(lhs), op(op), rhs(rhs) {}
    void accept(ASTVisitor *visitor);
  };

  class ASTIfElseStatement : public ASTStatement
  {
  public:
    ASTExpression &condition;
    ASTBlock &trueBlock;
    ASTBlock *falseBlock; // Pointer, because nullable
    ASTIfElseStatement(ASTExpression &condition, ASTBlock &trueBlock, ASTBlock *falseBlock) : condition(condition), trueBlock(trueBlock), falseBlock(falseBlock) {}
    void accept(ASTVisitor *visitor);
  };

  class ASTWhileStatement : public ASTStatement
  {
  public:
    ASTExpression &condition;
    ASTBlock &block;
    ASTWhileStatement(ASTExpression &condition, ASTBlock &block) : condition(condition), block(block) {}
    void accept(ASTVisitor *visitor);
  };

  class ASTStructDeclaration : public ASTStatement
  {
  public:
    ASTIdentifier &id;
    ASTVariableList arguments;
    ASTStructDeclaration(ASTIdentifier &id, const ASTVariableList &arguments) : id(id), arguments(arguments) {}
    ~ASTStructDeclaration()
    {
      std::cout << ">>>>>>>>>>>>> CLEAR ASTStructDeclaration " << std::endl;
      for (int i = 0; i < arguments.size(); i++)
      {
        delete arguments[i];
      }
    }
    void accept(ASTVisitor *visitor);
  };

  class ASTTypeConversion : public ASTExpression
  {
  public:
    ASTExpression &expression;
    ASTIdentifier &type;
    ASTTypeConversion(ASTExpression &expression, ASTIdentifier &type) : expression(expression), type(type) {}
    void accept(ASTVisitor *visitor);
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
  };

} // namespace stark

#endif