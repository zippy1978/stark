#include <iostream>
#include <vector>

class ASTStatement;
class ASTExpression;
class ASTVariableDeclaration;

typedef std::vector<ASTStatement*> ASTStatementList;
typedef std::vector<ASTExpression*> ASTExpressionList;
typedef std::vector<ASTVariableDeclaration*> ASTVariableList;

class ASTNode {
  public:
    virtual ~ASTNode() {}
};

class ASTExpression : public ASTNode {
};

class ASTStatement : public ASTNode {
};

class ASTInteger : public ASTExpression {
  public:
    long long value;
    ASTInteger(long long value) : value(value) {}
};

class ASTDouble : public ASTExpression {
  public:
    double value;
    ASTDouble(double value) : value(value) { }
};

class ASTIdentifier : public ASTExpression {
  public:
    std::string name;
    ASTIdentifier(const std::string& name) : name(name) { }
};

class ASTBlock : public ASTExpression {
public:
    ASTStatementList statements;
    ASTBlock() {}
};

class ASTAssignment : public ASTExpression {
  public:
    ASTIdentifier& lhs;
    ASTExpression& rhs;
    ASTAssignment(ASTIdentifier& lhs, ASTExpression& rhs) : lhs(lhs), rhs(rhs) {}
};

class ASTExpressionStatement : public ASTStatement {
public:
    ASTExpression& expression;
    ASTExpressionStatement(ASTExpression& expression) : expression(expression) {}
};

class ASTVariableDeclaration : public ASTStatement {
  public:
    const ASTIdentifier& type;
    ASTIdentifier& id;
    ASTExpression *assignmentExpr;
    ASTVariableDeclaration(const ASTIdentifier& type, ASTIdentifier& id) : type(type), id(id) {}
    ASTVariableDeclaration(const ASTIdentifier& type, ASTIdentifier& id, ASTExpression *assignmentExpr) : type(type), id(id), assignmentExpr(assignmentExpr) {}
};

class ASTFunctionDeclaration : public ASTStatement {
public:
    const ASTIdentifier& type;
    const ASTIdentifier& id;
    ASTVariableList arguments;
    ASTBlock& block;
    ASTFunctionDeclaration(const ASTIdentifier& type, const ASTIdentifier& id, const ASTVariableList& arguments, ASTBlock& block) : type(type), id(id), arguments(arguments), block(block) {}
};

class ASTMethodCall : public ASTExpression {
public:
    const ASTIdentifier& id;
    ASTExpressionList arguments;
    ASTMethodCall(const ASTIdentifier& id, ASTExpressionList& arguments) : id(id), arguments(arguments) {}
    ASTMethodCall(const ASTIdentifier& id) : id(id) {}
};
