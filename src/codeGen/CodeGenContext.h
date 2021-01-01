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


/**
 * Code generation block
 */
class CodeGenBlock {
  public:
    BasicBlock *block;
    std::map<std::string, Value*> locals;
    bool isMergeBlock;
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
    void setLocals(std::map<std::string, Value*>& l) { blocks.top()->locals = l; }
    BasicBlock *currentBlock() { return blocks.top()->block; }
    void pushBlock(BasicBlock *block) { blocks.push(new CodeGenBlock()); blocks.top()->isMergeBlock = false;blocks.top()->block = block; }
    void pushBlock(BasicBlock *block, bool inheritLocals) { std::map<std::string, Value*>& l = this->locals(); this->pushBlock(block); blocks.top()->locals = l; }
    void popBlock() { CodeGenBlock *top = blocks.top(); blocks.pop(); delete top; }
    bool isMergeBlock() { return blocks.top()->isMergeBlock; }
    void setMergeBlock(bool isMerge) { blocks.top()->isMergeBlock = isMerge ; }
};

#endif