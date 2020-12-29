#include <stack>
#include <typeinfo>
#include <llvm/ADT/APFloat.h>
#include <llvm/ADT/STLExtras.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Verifier.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include <llvm/ExecutionEngine/ExecutionEngine.h>
#include "ast.hh"

using namespace llvm;

static LLVMContext MyContext;
static IRBuilder<> Builder(MyContext);

class CodeGenVisitor;

class CodeGenBlock {
  public:
    BasicBlock *block;
    Value *returnValue;
    std::map<std::string, Value*> locals;
};

class CodeGenContext {
  std::stack<CodeGenBlock *> blocks;
  Function *mainFunction;
  CodeGenVisitor *visitor;

  public:
    Module *module;
    CodeGenContext() { module = new Module("main", MyContext); }
    
    void generateCode(ASTBlock& root);
    GenericValue runCode();
    std::map<std::string, Value*>& locals() { return blocks.top()->locals; }
    BasicBlock *currentBlock() { return blocks.top()->block; }
    void pushBlock(BasicBlock *block) { blocks.push(new CodeGenBlock()); blocks.top()->returnValue = NULL; blocks.top()->block = block; }
    void popBlock() { CodeGenBlock *top = blocks.top(); blocks.pop(); delete top; }
    void setCurrentReturnValue(Value *value) { blocks.top()->returnValue = value; }
    Value* getCurrentReturnValue() { return blocks.top()->returnValue; }
};

class CodeGenVisitor: public ASTVisitor {
  CodeGenContext *context;

  public:  
    CodeGenVisitor(CodeGenContext *context) : context(context) {}
    Value *result;
    void visit(ASTExpression *node);
    void visit(ASTInteger *node);
    void visit(ASTDouble *node);
    void visit(ASTIdentifier *node);
    void visit(ASTBlock *node);
    void visit(ASTAssignment *node);
    void visit(ASTExpressionStatement *node);
    void visit(ASTVariableDeclaration *node);
    void visit(ASTFunctionDeclaration *node);
    void visit(ASTMethodCall *node);
};