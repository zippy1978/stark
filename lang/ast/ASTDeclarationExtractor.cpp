#include <algorithm>

#include "ASTDeclarationExtractor.h"

namespace stark
{
    ASTIdentifier *ASTDeclarationExtractor::extractType(ASTIdentifier *typeId)
    {
        ASTIdentifier *result = nullptr;

        if (typeId != nullptr)
        {
            if (shouldPrefix(typeId))
            {
                ASTIdentifierList *members = new ASTIdentifierList();
                members->push_back(typeId->clone());
                result = new ASTIdentifier(moduleName, nullptr, members);
                delete members;
            }
            else
            {
                return typeId->clone();
            }
        }

        return result;
    }

    ASTVariableList ASTDeclarationExtractor::extractVariableList(ASTVariableList list)
    {
        ASTVariableList result;
        for (auto it = list.begin(); it != list.end(); it++)
        {
            ASTVariableDeclaration *vd = *it;
            ASTVariableDeclaration *newDeclaration = new ASTVariableDeclaration(extractType(vd->getType()), vd->getId()->clone(), vd->isArray(), vd->getAssignmentExpr() != nullptr ? vd->getAssignmentExpr()->clone() : nullptr);
            result.push_back(newDeclaration);
        }

        return result;
    }

    bool ASTDeclarationExtractor::isModuleType(ASTIdentifier *typeId)
    {
        // A module type : a type without prefix, that is not a builtin type
        return typeId->countNestedMembers() == 0 && (std::find(builtinTypeNames.begin(), builtinTypeNames.end(), typeId->getName()) == builtinTypeNames.end());
    }

    bool ASTDeclarationExtractor::shouldPrefix(ASTIdentifier *typeId)
    {
        // Prefix only for outside the module
        return isModuleType(typeId) && (moduleName.compare(targetModuleName) != 0);
    }

    void ASTDeclarationExtractor::visit(ASTInteger *node) {}
    void ASTDeclarationExtractor::visit(ASTBoolean *node) {}
    void ASTDeclarationExtractor::visit(ASTDouble *node) {}
    void ASTDeclarationExtractor::visit(ASTIdentifier *node) {}
    void ASTDeclarationExtractor::visit(ASTString *node) {}
    void ASTDeclarationExtractor::visit(ASTBlock *node)
    {
        ASTStatementList statements = node->getStatements();
        for (auto it = statements.begin(); it != statements.end(); it++)
        {
            ASTStatement *s = *it;
            s->accept(this);
        }
    }
    void ASTDeclarationExtractor::visit(ASTAssignment *node) {}
    void ASTDeclarationExtractor::visit(ASTExpressionStatement *node) {}
    void ASTDeclarationExtractor::visit(ASTVariableDeclaration *node) {}
    void ASTDeclarationExtractor::visit(ASTFunctionDefinition *node)
    {
        // Extract function definition to declaration
        if (node->getId()->getName().compare("main") != 0)
        {

            ASTVariableList arguments = node->getArguments();
            ASTVariableList clonedArguments = extractVariableList(node->getArguments());

            // Prefix id with module name
            ASTIdentifierList *members = new ASTIdentifierList();
            members->push_back(node->getId()->clone());
            ASTIdentifier *idWithModule = new ASTIdentifier(moduleName, nullptr, members);
            delete members;

            ASTFunctionDeclaration *fd = new ASTFunctionDeclaration(extractType(node->getType()), idWithModule, clonedArguments);
            fd->location = node->location;
            declarationBlock->addStatement(fd);
        }
    }
    void ASTDeclarationExtractor::visit(ASTFunctionCall *node) {}
    void ASTDeclarationExtractor::visit(ASTExternDeclaration *node) {}
    void ASTDeclarationExtractor::visit(ASTReturnStatement *node) {}
    void ASTDeclarationExtractor::visit(ASTBinaryOperation *node) {}
    void ASTDeclarationExtractor::visit(ASTComparison *node) {}
    void ASTDeclarationExtractor::visit(ASTIfElseStatement *node) {}
    void ASTDeclarationExtractor::visit(ASTWhileStatement *node) {}

    void ASTDeclarationExtractor::visit(ASTStructDeclaration *node)
    {
        // Export struct declaration from the local module
        if (node->getId()->countNestedMembers() == 0)
        {
            ASTVariableList clonedArguments = extractVariableList(node->getArguments());

            ASTIdentifier *id;
            // Add prefix only if target module is not the current module
            if (moduleName.compare(targetModuleName) != 0)
            {
                ASTIdentifierList *members = new ASTIdentifierList();
                members->push_back(node->getId()->clone());
                id = new ASTIdentifier(moduleName, nullptr, members);
                delete members;
            }
            else
            {
                id = node->getId()->clone();
            }

            ASTStructDeclaration *sd = new ASTStructDeclaration(id, clonedArguments);
            sd->location = node->location;
            declarationBlock->addStatement(sd);
        }
    }

    void ASTDeclarationExtractor::visit(ASTArray *node) {}
    void ASTDeclarationExtractor::visit(ASTTypeConversion *node) {}
    void ASTDeclarationExtractor::visit(ASTFunctionDeclaration *node) {}
    void ASTDeclarationExtractor::visit(ASTModuleDeclaration *node)
    {
        moduleName = node->getId()->getFullName();
    }
    void ASTDeclarationExtractor::visit(ASTImportDeclaration *node)
    {
        declarationBlock->addStatement(node->clone());
    }
    void ASTDeclarationExtractor::visit(ASTNull *node) {}

} // namespace stark