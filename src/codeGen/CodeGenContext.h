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
   * Represents a code block.
   * Wraps a llvm::BasicBlock 
   * and other information useful for the block creation.
   */
  class CodeGenBlock
  {
  public:
    BasicBlock *block;
    /* Holds local variables declared into the block */
    std::map<std::string, CodeGenVariable *> locals;
    /**
     * Indicates if the block is a merge block.
     * A merge block is the last block delcared in a control flow instruction.
     */
    bool isMergeBlock;
    Value *returnValue;
  };

  /**
   * Code generation context.
   * Is in charge of generating llvm program code from AST.
   */
  class CodeGenContext
  {

    /* Block stack */
    std::stack<CodeGenBlock *> blocks;

    /* Program main function */
    Function *mainFunction;

    /* Holds language complex types (built-in and custom) */
    std::map<std::string, CodeGenComplexType *> complexTypes;

  private:
    /* Declare built-in complex types into the LLVMContext */
    void declareComplexTypes();

  public:
    Module *module;
    LLVMContext llvmContext;
    stark::Logger logger;

    

    // TODO : "main" should be the source file name
    CodeGenContext() { module = new Module("main", llvmContext); }

    /* Generate llvm program code */
    void generateCode(ASTBlock &root);

    /* Execute geenrated program code */
    GenericValue runCode();

    /* Generate a complex type declaration */
    void declareComplexType(CodeGenComplexType *complexType);
    CodeGenComplexType *getComplexType(std::string name);

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