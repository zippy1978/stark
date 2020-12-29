
#ifndef AST_HH
#define AST_HH

#include <iostream>
#include <vector>

class ASTVisitor;
class ASTStatement;
class ASTExpression;
class ASTVariableDeclaration;

typedef std::vector<ASTStatement*> ASTStatementList;
typedef std::vector<ASTExpression*> ASTExpressionList;
typedef std::vector<ASTVariableDeclaration*> ASTVariableList;

class ASTNode {
  public:
    virtual ~ASTNode() {}
    virtual void accept(ASTVisitor *visitor) = 0;
};

class ASTExpression : public ASTNode {
  public:
    virtual ~ASTExpression() {}
};

class ASTStatement : public ASTNode {
  public:
    virtual ~ASTStatement() {}
};

class ASTInteger : public ASTExpression {
  public:
    long long value;
    ASTInteger(long long value) : value(value) {}
    void accept(ASTVisitor *visitor);
};

class ASTDouble : public ASTExpression {
  public:
    double value;
    ASTDouble(double value) : value(value) {}
    void accept(ASTVisitor *visitor);
};

class ASTIdentifier : public ASTExpression {
  public:
    std::string name;
    ASTIdentifier(const std::string& name) : name(name) {}
    void accept(ASTVisitor *visitor);
};

class ASTBlock : public ASTExpression {
public:
    ASTStatementList statements;
    ASTBlock() {}
    void accept(ASTVisitor *visitor);
};

class ASTAssignment : public ASTExpression {
  public:
    ASTIdentifier& lhs;
    ASTExpression& rhs;
    ASTAssignment(ASTIdentifier& lhs, ASTExpression& rhs) : lhs(lhs), rhs(rhs) {}
    void accept(ASTVisitor *visitor);
};

class ASTExpressionStatement : public ASTStatement {
  public:
    ASTExpression& expression;
    ASTExpressionStatement(ASTExpression& expression) : expression(expression) {}
    void accept(ASTVisitor *visitor);
};

class ASTVariableDeclaration : public ASTStatement {
  public:
    const ASTIdentifier& type;
    ASTIdentifier& id;
    ASTExpression *assignmentExpr;
    ASTVariableDeclaration(const ASTIdentifier& type, ASTIdentifier& id) : type(type), id(id) {}
    ASTVariableDeclaration(const ASTIdentifier& type, ASTIdentifier& id, ASTExpression *assignmentExpr) : type(type), id(id), assignmentExpr(assignmentExpr) {}
    void accept(ASTVisitor *visitor);
};

class ASTFunctionDeclaration : public ASTStatement {
  public:
    const ASTIdentifier& type;
    const ASTIdentifier& id;
    ASTVariableList arguments;
    ASTBlock& block;
    ASTFunctionDeclaration(const ASTIdentifier& type, const ASTIdentifier& id, const ASTVariableList& arguments, ASTBlock& block) : type(type), id(id), arguments(arguments), block(block) {}
    void accept(ASTVisitor *visitor);
};

class ASTMethodCall : public ASTExpression {
  public:
    const ASTIdentifier& id;
    ASTExpressionList arguments;
    ASTMethodCall(const ASTIdentifier& id, ASTExpressionList& arguments) : id(id), arguments(arguments) {}
    ASTMethodCall(const ASTIdentifier& id) : id(id) {}
    void accept(ASTVisitor *visitor);
};


class ASTVisitor {
  public:
    virtual void visit(ASTExpression *node) = 0;
    virtual void visit(ASTInteger *node) = 0;
    virtual void visit(ASTDouble *node) = 0;
    virtual void visit(ASTIdentifier *node) = 0;
    virtual void visit(ASTBlock *node) = 0;
    virtual void visit(ASTAssignment *node) = 0;
    virtual void visit(ASTExpressionStatement *node) = 0;
    virtual void visit(ASTVariableDeclaration *node) = 0;
    virtual void visit(ASTFunctionDeclaration *node) = 0;
    virtual void visit(ASTMethodCall *node) = 0;
};

#endif