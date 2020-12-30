#ifndef CODEGEN_CODEGENCONTEXT_H
#define CODEGEN_CODEGENCONTEXT_H

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
#include <llvm/Support/FormatVariadic.h>
// This is the interpreter implementation
#include <llvm/ExecutionEngine/MCJIT.h>

#include "../ast/AST.h"
#include "CodeGenLogger.h"

using namespace llvm;

// Global LLVM context
static LLVMContext MyContext;
//static IRBuilder<> Builder(MyContext); // Not used at the moment


/**
 * Code generation block
 */
class CodeGenBlock {
  public:
    BasicBlock *block;
    Value *returnValue;
    std::map<std::string, Value*> locals;
};

/**
 * Code generation context
 */
class CodeGenContext {
  std::stack<CodeGenBlock *> blocks;
  Function *mainFunction;

  public:
    Module *module;
    CodeGenLogger logger;
    // TOTO : "main" should be the source file name
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

#endif