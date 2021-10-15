#include "ASTWriter.h"

namespace stark
{
    void ASTWriter::visit(ASTInteger *node)
    {
        output << node->getValue();
    }

    void ASTWriter::visit(ASTBoolean *node)
    {
        node->getValue() ? output << "true" : output << "false";
    }

    void ASTWriter::visit(ASTDouble *node)
    {
        output << node->getValue();
    }

    void ASTWriter::visit(ASTIdentifier *node)
    {

        output << node->getName();

        if (node->getIndex() != nullptr)
        {
            output << "[";
            node->getIndex()->accept(this);
            output << "]";
        }

        if (node->isArray())
        {
        }

        if (node->getMember() != nullptr)
        {
            // Pass array typing on to the next member (if not index)
            if (node->isArray() && node->getIndex() == nullptr)
            {
                node->getMember()->setArray(true);
            }
            output << ".";
            node->getMember()->accept(this);
        }
        // Last member of the identifier : array case
        else
        {
            if (node->isArray() && node->getIndex() == nullptr)
            {
                output << "[]";
            }
        }
    }

    void ASTWriter::visit(ASTString *node)
    {

        output << "\"" << node->getValue() << "\"";
    }

    void ASTWriter::visit(ASTBlock *node)
    {
        ASTStatementList sts = node->getStatements();
        for (auto it = sts.begin(); it != sts.end(); it++)
        {
            ASTStatement *s = *it;
            s->accept(this);
            output << std::endl;
        }
    }

    void ASTWriter::visit(ASTAssignment *node)
    {
        node->getLhs()->accept(this);
        output << " = ";
        node->getRhs()->accept(this);
    }

    void ASTWriter::visit(ASTExpressionStatement *node)
    {
        node->getExpression()->accept(this);
    }

    void ASTWriter::visit(ASTVariableDeclaration *node)
    {
        node->getId()->accept(this);
        output << ": ";
        if (node->getType() != nullptr)
        {
            node->getType()->accept(this);
        }
        if (node->getFunctionSignature() != nullptr)
        {
            
            node->getFunctionSignature()->accept(this);
        }

        if (node->getAssignmentExpr() != nullptr)
        {
            node->getAssignmentExpr()->accept(this);
        }
    }

    void ASTWriter::visit(ASTFunctionSignature *node)
    {
        if (node->isArray())
        {
            output << "(";
        }
        if (!node->isClosure())
        {
            output << "func ";
        }
        output << "(";
        ASTIdentifierList args = node->getArguments();
        int i = 0;
        for (auto it = args.begin(); it != args.end(); it++)
        {
            ASTIdentifier *id = *it;
            id->accept(this);
            if (i < (args.size() - 1))
            {
                output << ", ";
            }
            i++;
        }
        output << ") => ";
        if (node->getType() != nullptr)
        {
            node->getType()->accept(this);
        }
        if (node->getFunctionSignature() != nullptr)
        {
            node->getFunctionSignature()->accept(this);
        }

        if (node->isArray())
        {
            output << ") []";
        }
    }

    void ASTWriter::visit(ASTAnonymousFunction *node)
    {
        output << "(";
        ASTVariableList args = node->getArguments();
        int i = 0;
        for (auto it = args.begin(); it != args.end(); it++)
        {
            ASTVariableDeclaration *v = *it;
            v->accept(this);
            if (i < (args.size() - 1))
            {
                output << ", ";
            }
            i++;
        }

        output << ") => ";
        if (node->getType() != nullptr)
        {
            node->getType()->accept(this);
        }
        if (node->getFunctionSignatureType() != nullptr)
        {
            node->getFunctionSignatureType()->accept(this);
        }
        output << "{\n";
        node->getBlock()->accept(this);
        output << "}";
    }

    void ASTWriter::visit(ASTFunctionCall *node)
    {
        node->getId()->accept(this);
        output << "(";
        ASTExpressionList args = node->getArguments();
        int i = 0;
        for (auto it = args.begin(); it != args.end(); it++)
        {
            ASTExpression *e = *it;
            e->accept(this);
            if (i < (args.size() - 1))
            {
                output << ", ";
            }
            i++;
        }
    }

    void ASTWriter::visit(ASTReturnStatement *node)
    {

        output << "return ";
        node->getExpression()->accept(this);
    }

    void ASTWriter::visit(ASTBinaryOperation *node)
    {
        node->getLhs()->accept(this);
        ASTBinaryOperator op = node->getOp();
        switch (op)
        {
        case AND:
            output << " && ";
            break;
        case OR:
            output << " || ";
            break;
        case ADD:
            output << " + ";
            break;
        case SUB:
            output << " - ";
            break;
        case MUL:
            output << " * ";
            break;
        case DIV:
            output << " / ";
            break;
        default:
            break;
        }
        node->getRhs()->accept(this);
    }

    void ASTWriter::visit(ASTComparison *node)
    {
        node->getLhs()->accept(this);
        ASTComparisonOperator op = node->getOp();
        switch (op)
        {
        case EQ:
            output << " == ";
            break;
        case NE:
            output << " != ";
            break;
        case LT:
            output << " < ";
            break;
        case LE:
            output << " <= ";
            break;
        case GT:
            output << " > ";
            break;
        case GE:
            output << " >= ";
            break;
        default:
            break;
        }
        node->getRhs()->accept(this);
    }

    void ASTWriter::visit(ASTIfElseStatement *node)
    {
        output << "if (";
        node->getCondition()->accept(this);
        output << ") {\n";
        node->getTrueBlock()->accept(this);
        if (node->getFalseBlock() != nullptr)
        {
            output << "} else {";
            node->getFalseBlock()->accept(this);
        }
        output << "}";
    }

    void ASTWriter::visit(ASTWhileStatement *node)
    {
        output << "while (";
        node->getCondition()->accept(this);
        output << ") {\n";
        node->getBlock()->accept(this);
        output << "}";
    }

    void ASTWriter::visit(ASTStructDeclaration *node)
    {
        output << "struct ";
        node->getId()->accept(this);
        output << "{";
        ASTVariableList args = node->getArguments();
        int i = 0;
        for (auto it = args.begin(); it != args.end(); it++)
        {
            ASTVariableDeclaration *v = *it;
            v->accept(this);
            if (i < (args.size() - 1))
            {
                output << ", ";
            }
            i++;
        }
        output << "}";
    }

    void ASTWriter::visit(ASTArray *node)
    {
        output << "[";
        ASTExpressionList args = node->getArguments();
        int i = 0;
        for (auto it = args.begin(); it != args.end(); it++)
        {
            ASTExpression *e = *it;
            e->accept(this);
            if (i < (args.size() - 1))
            {
                output << ",";
            }
            i++;
        }
        output << "]";
    }

    void ASTWriter::visit(ASTTypeConversion *node)
    {
        node->getExpression()->accept(this);
        output << " as ";
        node->getType()->accept(this);
    }

    void ASTWriter::visit(ASTFunctionDeclaration *node)
    {
        if (node->getBlock() != nullptr)
        {
            output << "func ";
        }
        else
        {
            if (node->isExternal())
            {
                output << "extern ";
            }
            else
            {
                output << "declare ";
            }
        }

        node->getId()->accept(this);
        output << "(";
        ASTVariableList args = node->getArguments();
        int i = 0;
        for (auto it = args.begin(); it != args.end(); it++)
        {
            ASTVariableDeclaration *v = *it;
            v->accept(this);
            if (i < (args.size() - 1))
            {
                output << ", ";
            }
            i++;
        }
        output << ") => ";
        if (node->getType() != nullptr)
        {
            node->getType()->accept(this);
        }
        if (node->getFunctionSignatureType() != nullptr)
        {
            node->getFunctionSignatureType()->accept(this);
        }
        if (node->getBlock() != nullptr)
        {
            output << "{\n";
            node->getBlock()->accept(this);
            output << "}";
        }
    }

    void ASTWriter::visit(ASTModuleDeclaration *node)
    {
        output << "module ";
        node->getId()->accept(this);
    }

    void ASTWriter::visit(ASTImportDeclaration *node)
    {
        output << "import ";
        node->getId()->accept(this);
    }

    void ASTWriter::visit(ASTNull *node)
    {
        output << "null";
    }

} // namespace stark