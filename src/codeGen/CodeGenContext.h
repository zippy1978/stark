#ifndef CODEGEN_CODEGENCONTEXT_H
#define CODEGEN_CODEGENCONTEXT_H

#include <stack>
#include <typeinfo>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include <llvm/Support/FormatVariadic.h>

#include "../ast/AST.h"
#include "CodeGenLogger.h"

using namespace llvm;

// Global LLVM context
static LLVMContext MyContext;

/**
 * Code generation block
 */
class CodeGenBlock
{
public:
  BasicBlock *block;
  std::map<std::string, Value *> locals;
  bool isMergeBlock;
  Value *returnValue;
};

/**
 * Code generation context
 */
class CodeGenContext
{
  std::stack<CodeGenBlock *> blocks;
  Function *mainFunction;

public:
  Module *module;
  CodeGenLogger logger;
  // TOTO : "main" should be the source file name
  CodeGenContext() { module = new Module("main", MyContext); }

  void generateCode(ASTBlock &root);
  GenericValue runCode();
  std::map<std::string, Value *> &locals() { return blocks.top()->locals; }
  void setLocals(std::map<std::string, Value *> &l) { blocks.top()->locals = l; }
  BasicBlock *currentBlock() { return blocks.top()->block; }
  void pushBlock(BasicBlock *block);
  void pushBlock(BasicBlock *block, bool inheritLocals);
  void popBlock();
  bool isMergeBlock() { return blocks.top()->isMergeBlock; }
  void setMergeBlock(bool isMerge) { blocks.top()->isMergeBlock = isMerge; }
  Value *returnValue() { return blocks.top()->returnValue; }
  void setReturnValue(Value *value) { blocks.top()->returnValue = value; }
};

#endif