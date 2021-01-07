#ifndef CODEGEN_CODEGENCONTEXT_H
#define CODEGEN_CODEGENCONTEXT_H

#include <stack>
#include <typeinfo>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include <llvm/Support/FormatVariadic.h>

#include "../lang/ast/AST.h"
#include "../util/Util.h"

#include "CodeGenComplexType.h"
#include "CodeGenVariable.h"

using namespace llvm;

namespace stark
{

  /**
 * Code generation block
 */
  class CodeGenBlock
  {
  public:
    BasicBlock *block;
    std::map<std::string, CodeGenVariable *> locals;
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

  private:
    void declareComplexTypes();

  public:
    Module *module;
    LLVMContext llvmContext;
    stark::Logger logger;

    /* Holds language complex types */
    std::map<std::string, CodeGenComplexType *> complexTypes;

    // TOTO : "main" should be the source file name
    CodeGenContext() { module = new Module("main", llvmContext); }

    void generateCode(ASTBlock &root);
    GenericValue runCode();
    std::map<std::string, CodeGenVariable *> &locals() { return blocks.top()->locals; }
    void setLocals(std::map<std::string, CodeGenVariable *> &l) { blocks.top()->locals = l; }
    BasicBlock *currentBlock() { return blocks.top()->block; }
    void pushBlock(BasicBlock *block);
    void pushBlock(BasicBlock *block, bool inheritLocals);
    void popBlock();
    bool isMergeBlock() { return blocks.top()->isMergeBlock; }
    void setMergeBlock(bool isMerge) { blocks.top()->isMergeBlock = isMerge; }
    Value *returnValue() { return blocks.top()->returnValue; }
    void setReturnValue(Value *value) { blocks.top()->returnValue = value; }
  };

} // namespace stark

#endif