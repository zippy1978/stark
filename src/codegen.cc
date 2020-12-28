#include <llvm/IR/LLVMContext.h>
#include "codegen.hh"

using namespace llvm;

static LLVMContext TheContext;
//static IRBuilder<> Builder(TheContext);
//static std::unique_ptr<Module> TheModule;
//static std::map<std::string, Value *> NamedValues;


void CodeGenVisitor::visit(ASTExpression *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTStatement *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTInteger *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTDouble *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTIdentifier *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTBlock *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTAssignment *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTExpressionStatement *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTVariableDeclaration *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTFunctionDeclaration *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTMethodCall *node) {
    // TODO
}


