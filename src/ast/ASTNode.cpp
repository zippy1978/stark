#include "ASTNode.h"

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
    void ASTFunctionDefinition::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTFunctionCall::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTExternDeclaration::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTReturnStatement::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTBinaryOperation::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTComparison::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTIfElseStatement::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTWhileStatement::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTStructDeclaration::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTArray::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTTypeConversion::accept(ASTVisitor *visitor) { visitor->visit(this); }
    void ASTFunctionDeclaration::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTIdentifier::ASTIdentifier(std::string name, ASTExpression *index, ASTIdentifierList *members)
    {
        this->name = name;
        this->index = std::unique_ptr<ASTExpression>(index);

        // Build members from list
        ASTIdentifierList::const_iterator it;
        ASTIdentifier *memberIdentifier = nullptr;
        ASTIdentifier *parentIdentifier = nullptr;
        if (members != nullptr)
        {
            for (it = members->begin(); it != members->end(); it++)
            {
                ASTIdentifier *currentIdentifier = *it;

                if (memberIdentifier == nullptr)
                {
                    memberIdentifier = currentIdentifier;
                }

                if (parentIdentifier != nullptr)
                {
                    parentIdentifier->member = std::unique_ptr<ASTIdentifier>(currentIdentifier);
                }

                parentIdentifier = currentIdentifier;
            }
        }

        this->member = std::unique_ptr<ASTIdentifier>(memberIdentifier);
    }

    int ASTIdentifier::countNestedMembers()
    {
        int result = 0;

        ASTIdentifier *ident = this;
        while (ident->member != nullptr)
        {
            result++;
            ident = ident->getMember();
        }

        return result;
    }

    std::string ASTIdentifier::getFullName()
    {
        std::string result = this->name;

        if (this->index != nullptr)
        {
            result.append("[expr]");
        }

        ASTIdentifier *ident = this;
        while (ident->member != nullptr)
        {
            result.append(".").append(ident->member->name);
            if (ident->member->index != nullptr)
            {
                result.append("[expr]");
            }
            ident = ident->getMember();
        }

        return result;
    }

} // namespace stark
