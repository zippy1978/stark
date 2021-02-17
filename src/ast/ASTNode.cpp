#include "ASTNode.h"

namespace stark
{
    static bool compareStatements(ASTStatement *first, ASTStatement *second)
    {
        return first->getPriority() < second->getPriority();
    }

    /** Creates a deep copy of a ASTStatementList */
    static ASTStatementList cloneList(ASTStatementList list)
    {
        ASTStatementList clone;

        for (auto it = list.begin(); it != list.end(); it++)
        {
            ASTStatement *s = *it;
            clone.push_back(s->clone());
        }

        return clone;
    }

    /** Deletes an ASTStatementList */
    static void deleteList(ASTStatementList list)
    {
        for (int i = 0; i < list.size(); i++)
            delete list[i];
    }

    /** Creates a deep copy of a ASTVariableList */
    static ASTVariableList cloneList(ASTVariableList list)
    {
        ASTVariableList clone;

        for (auto it = list.begin(); it != list.end(); it++)
        {
            ASTVariableDeclaration *s = *it;
            clone.push_back(s->clone());
        }

        return clone;
    }

    /** Deletes an ASTVariableList */
    static void deleteList(ASTVariableList list)
    {
        for (int i = 0; i < list.size(); i++)
            delete list[i];
    }

    /** Creates a deep copy of a ASTExpressionList */
    static ASTExpressionList cloneList(ASTExpressionList list)
    {
        ASTExpressionList clone;

        for (auto it = list.begin(); it != list.end(); it++)
        {
            ASTExpression *s = *it;
            clone.push_back(s->clone());
        }

        return clone;
    }

    /** Deletes an ASTExpressionList */
    static void deleteList(ASTExpressionList list)
    {
        for (int i = 0; i < list.size(); i++)
            delete list[i];
    }

    // ASTInteger

    void ASTInteger::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTInteger *ASTInteger::clone()
    {
        return new ASTInteger(this->value);
    }

    // ASTBoolean

    void ASTBoolean::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTBoolean *ASTBoolean::clone()
    {
        return new ASTBoolean(this->value);
    }

    // ASTDouble

    void ASTDouble::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTDouble *ASTDouble::clone()
    {
        return new ASTDouble(this->value);
    }

    // ASTString

    void ASTString::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTString *ASTString::clone()
    {
        return new ASTString(this->value);
    }

    // ASTIdentifier

    void ASTIdentifier::accept(ASTVisitor *visitor) { visitor->visit(this); }

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

    ASTIdentifier *ASTIdentifier::clone()
    {
        ASTIdentifier *clone = new ASTIdentifier(this->getName(), this->getIndex() != nullptr ? this->getIndex()->clone() : nullptr, nullptr);
        if (this->getMember() != nullptr)
            clone->member = std::unique_ptr<ASTIdentifier>(this->getMember()->clone());
        return clone;
    }

    // ASTBlock

    ASTBlock::~ASTBlock()
    {
        deleteList(statements);
    }

    void ASTBlock::preprend(ASTBlock *block)
    {

        int offset = 0;
        if (this->statements.size() > 0)
        {
            if (dynamic_cast<ASTModuleDeclaration *>(this->statements[0]))
            {
                offset = 1;
            }
        }

        // Insert a clone of each statement of the new block
        ASTStatementList clonedSts = cloneList(block->statements);
        statements.insert(statements.begin() + offset, clonedSts.begin(), clonedSts.end());
    }

    void ASTBlock::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTBlock *ASTBlock::clone()
    {
        ASTBlock *clone = new ASTBlock();
        clone->statements = cloneList(this->statements);
        return clone;
    }

    void ASTBlock::sort()
    {
        std::sort (statements.begin(), statements.end(), compareStatements);
    }

    // ASTAssignment

    void ASTAssignment::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTAssignment *ASTAssignment::clone()
    {
        return new ASTAssignment(this->getLhs()->clone(), this->getRhs()->clone());
    }

    // ASTExpressionStatement

    void ASTExpressionStatement::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTExpressionStatement *ASTExpressionStatement::clone()
    {
        return new ASTExpressionStatement(this->getExpression()->clone());
    }

    // ASTVariableDeclaration

    void ASTVariableDeclaration::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTVariableDeclaration *ASTVariableDeclaration::clone()
    {
        return new ASTVariableDeclaration(this->getType()->clone(), this->getId()->clone(), this->isArray(), this->getAssignmentExpr() != nullptr ? this->getAssignmentExpr()->clone() : nullptr);
    }

    // ASTFunctionDefinition

    void ASTFunctionDefinition::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTFunctionDefinition::~ASTFunctionDefinition()
    {
        deleteList(arguments);
    }

    ASTFunctionDefinition *ASTFunctionDefinition::clone()
    {
        ASTVariableList arguments = cloneList(this->getArguments());
        return new ASTFunctionDefinition(this->getType()->clone(), this->getId()->clone(), arguments, this->getBlock()->clone());
    }

    // ASTFunctionCall

    void ASTFunctionCall::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTFunctionCall::~ASTFunctionCall()
    {
        deleteList(arguments);
    }

    ASTFunctionCall *ASTFunctionCall::clone()
    {
        ASTExpressionList arguments = cloneList(this->getArguments());
        return new ASTFunctionCall(this->getId()->clone(), arguments);
    }

    // ASTExternDeclaration

    void ASTExternDeclaration::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTExternDeclaration *ASTExternDeclaration::clone()
    {
        ASTVariableList arguments = cloneList(this->getArguments());
        return new ASTExternDeclaration(this->getType()->clone(), this->getId()->clone(), arguments);
    }

    // ASTReturnStatement

    void ASTReturnStatement::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTReturnStatement *ASTReturnStatement::clone()
    {
        return new ASTReturnStatement(this->getExpression()->clone());
    }

    // ASTBinaryOperation

    void ASTBinaryOperation::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTBinaryOperation *ASTBinaryOperation::clone()
    {
        return new ASTBinaryOperation(this->getLhs()->clone(), this->getOp(), this->getRhs()->clone());
    }

    // ASTComparison

    void ASTComparison::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTComparison *ASTComparison::clone()
    {
        return new ASTComparison(this->getLhs()->clone(), this->getOp(), this->getRhs()->clone());
    }

    // ASTIfElseStatement

    void ASTIfElseStatement::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTIfElseStatement *ASTIfElseStatement::clone()
    {
        return new ASTIfElseStatement(this->getCondition()->clone(), this->getTrueBlock()->clone(), this->getFalseBlock() != nullptr ? this->getFalseBlock()->clone() : nullptr);
    }

    // ASTWhileStatement

    void ASTWhileStatement::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTWhileStatement *ASTWhileStatement::clone()
    {
        return new ASTWhileStatement(this->getCondition()->clone(), this->getBlock()->clone());
    }

    // ASTStructDeclaration

    void ASTStructDeclaration::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTStructDeclaration::~ASTStructDeclaration()
    {
        deleteList(arguments);
    }

    ASTStructDeclaration *ASTStructDeclaration::clone()
    {
        ASTVariableList arguments = cloneList(this->getArguments());
        return new ASTStructDeclaration(this->getId()->clone(), arguments);
    }

    // ASTArray

    ASTArray::~ASTArray()
    {
        deleteList(arguments);
    }

    void ASTArray::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTArray *ASTArray::clone()
    {
        ASTExpressionList arguments = cloneList(this->arguments);
        return new ASTArray(arguments);
    }

    // ASTTypeConversion

    void ASTTypeConversion::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTTypeConversion *ASTTypeConversion::clone()
    {
        return new ASTTypeConversion(this->getExpression()->clone(), this->getType()->clone());
    }

    // ASTFunctionDeclaration

    void ASTFunctionDeclaration::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTFunctionDeclaration::~ASTFunctionDeclaration()
    {
        deleteList(arguments);
    }

    ASTFunctionDeclaration *ASTFunctionDeclaration::clone()
    {
        ASTVariableList arguments = cloneList(this->getArguments());
        return new ASTFunctionDeclaration(this->getType()->clone(), this->getId()->clone(), arguments);
    }

    // ASTModuleDeclaration
    void ASTModuleDeclaration::accept(ASTVisitor *visitor) { visitor->visit(this); }

    ASTModuleDeclaration *ASTModuleDeclaration::clone()
    {
        return new ASTModuleDeclaration(this->getId()->clone());
    }

} // namespace stark
