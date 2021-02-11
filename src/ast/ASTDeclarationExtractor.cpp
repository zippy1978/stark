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
        for (auto it = node->statements.begin(); it != node->statements.end(); it++)
        {
            (**it).accept(this);
        }
    }
    void ASTDeclarationExtractor::visit(ASTAssignment *node) {}
    void ASTDeclarationExtractor::visit(ASTExpressionStatement *node) {}
    void ASTDeclarationExtractor::visit(ASTVariableDeclaration *node) {}
    void ASTDeclarationExtractor::visit(ASTFunctionDefinition *node)
    {
        if (node->id.getName().compare("main") != 0)
        {
            ASTFunctionDeclaration *fd = new ASTFunctionDeclaration(node->type, node->id, node->arguments);
            declarationBlock->statements.push_back(fd);
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
        declarationBlock->statements.push_back(node);
    }

    void ASTDeclarationExtractor::visit(ASTArray *node) {}
    void ASTDeclarationExtractor::visit(ASTTypeConversion *node) {}
    void ASTDeclarationExtractor::visit(ASTFunctionDeclaration *node) {}

} // namespace stark