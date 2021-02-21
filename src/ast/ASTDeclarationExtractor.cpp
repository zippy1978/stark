#include "ASTDeclarationExtractor.h"

namespace stark
{
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
        if (node->getId()->getName().compare("main") != 0)
        {
            ASTVariableList arguments = node->getArguments();
            ASTVariableList clonedArguments;
            for (auto it = arguments.begin(); it != arguments.end(); it++)
            {
                ASTVariableDeclaration *s = *it;
                clonedArguments.push_back(s->clone());
            }

            ASTFunctionDeclaration *fd = new ASTFunctionDeclaration(node->getType()->clone(), node->getId()->clone(), clonedArguments);
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
        declarationBlock->addStatement(node->clone());
    }

    void ASTDeclarationExtractor::visit(ASTArray *node) {}
    void ASTDeclarationExtractor::visit(ASTTypeConversion *node) {}
    void ASTDeclarationExtractor::visit(ASTFunctionDeclaration *node) {}
    void ASTDeclarationExtractor::visit(ASTModuleDeclaration *node) {}
    void ASTDeclarationExtractor::visit(ASTImportDeclaration *node) 
    {
        declarationBlock->addStatement(node->clone());
    }

} // namespace stark