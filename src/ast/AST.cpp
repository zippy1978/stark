#include "AST.h"

namespace stark
{
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
    void ASTFunctionCall::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTExternDeclaration::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTReturnStatement::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTBinaryOperation::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTComparison::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTIfElseStatement::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTWhileStatement::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTStructDeclaration::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTArray::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTIdentifier::ASTIdentifier(const std::string &name, ASTExpression *index, ASTIdentifierList *members)
    {
        this->name = name;
        this->index = index;

        // Build members from list
        ASTIdentifierList::const_iterator it;
        ASTIdentifier *memberIdentifier = NULL;
        ASTIdentifier *parentIdentifier = NULL;
        if (members != NULL)
        {
            for (it = members->begin(); it != members->end(); it++)
            {
                ASTIdentifier *currentIdentifier = *it;

                if (memberIdentifier == NULL)
                {
                    memberIdentifier = currentIdentifier;
                }

                if (parentIdentifier != NULL)
                {
                    parentIdentifier->member = currentIdentifier;
                }

                parentIdentifier = currentIdentifier;
            }
                }

        this->member = memberIdentifier;

    }

} // namespace stark
