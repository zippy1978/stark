#include "AST.h"

void ASTInteger::accept(ASTVisitor *visitor) { visitor->visit(this); }
void ASTBoolean::accept(ASTVisitor *visitor) { visitor->visit(this); }
void ASTDouble::accept(ASTVisitor *visitor) { visitor->visit(this); }
void ASTString::accept(ASTVisitor *visitor) { visitor->visit(this); }
void ASTIdentifier::accept(ASTVisitor *visitor) { visitor->visit(this); }
void ASTBlock::accept(ASTVisitor *visitor) { visitor->visit(this); }
void ASTAssignment::accept(ASTVisitor *visitor) { visitor->visit(this); }
void ASTExpressionStatement::accept(ASTVisitor *visitor) { visitor->visit(this); }
void ASTVariableDeclaration::accept(ASTVisitor *visitor) { visitor->visit(this); }
void ASTFunctionDeclaration::accept(ASTVisitor *visitor) { visitor->visit(this); }
void ASTMethodCall::accept(ASTVisitor *visitor) { visitor->visit(this); }
void ASTExternDeclaration::accept(ASTVisitor *visitor) { visitor->visit(this); }
void ASTReturnStatement::accept(ASTVisitor *visitor) { visitor->visit(this); }
void ASTBinaryOperator::accept(ASTVisitor *visitor) { visitor->visit(this); }

