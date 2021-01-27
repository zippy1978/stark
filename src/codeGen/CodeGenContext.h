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
#include "../util/Util.h"

#include "types/CodeGenComplexType.h"
#include "types/CodeGenPrimaryType.h"
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

    /* Name of the file being processed */
    std::string filename = NULL;

    /* Block stack */
    std::stack<CodeGenBlock *> blocks;

    /* Program main function */
    Function *mainFunction;

    /* Holds language complex types (built-in and custom) */
    std::map<std::string, CodeGenComplexType *> complexTypes;

    /* Holds array types (by type) */
    std::map<std::string, CodeGenComplexType *> arrayComplexTypes;

    /* Holds primary types */
    std::map<std::string, CodeGenPrimaryType *> primaryTypes;

    /* Run code generation in debug mode if enabled */
    bool debugEnabled = false;

    /* If set to true : generates a wrapping main function on the source file nd inject args (as string[] in the scope) */
    bool interpreterMode = false;

    /* Indicate if GC was initialized */
    bool gcInitialized = false;

  private:
    /* Declare built-in complex types into the LLVMContext */
    void declareComplexTypes();

    /* Register primary types */
    void registerPrimaryTypes();

  public:
    Module *module;
    LLVMContext llvmContext;
    stark::Logger logger;

    CodeGenContext(std::string filename) : filename(filename) { module = new Module(filename, llvmContext); }

    /* Generate llvm program code */
    void generateCode(ASTBlock &root);

    /* Execute generated program code */
    int runCode(int argc, char *argv[]);

    /* Write generated code to file */
    void writeCode(std::string filename);

    /* Generate a complex type declaration */
    void declareComplexType(CodeGenComplexType *complexType);

    /* Return matching complex type information from a type name */
    CodeGenComplexType *getComplexType(std::string typeName);

    /* Return matching array type (complex type) for a given enclosing type name */
    CodeGenComplexType *getArrayComplexType(std::string typeName);

    /* Return matching primary type from a type name */
    CodeGenPrimaryType *getPrimaryType(std::string typeName);

    /* Return LLVM type from a type name */
    Type *getType(std::string typeName);

    /* Try to find type name from LLVM type */
    std::string getTypeName(Type *type);

    void declareLocal(CodeGenVariable *var);
    CodeGenVariable *getLocal(std::string name);

    BasicBlock *getCurrentBlock() { return blocks.top()->block; }
    void pushBlock(BasicBlock *block);
    void pushBlock(BasicBlock *block, bool inheritLocals);
    void popBlock();
    bool isMergeBlock() { return blocks.top()->isMergeBlock; }
    void setMergeBlock(bool isMerge) { blocks.top()->isMergeBlock = isMerge; }

    Value *getReturnValue() { return blocks.top()->returnValue; }
    void setReturnValue(Value *value) { blocks.top()->returnValue = value; }

    void setDebugEnabled(bool d) { debugEnabled = d; }
    void setInterpreterMode(bool m) { interpreterMode = m; }
    bool isInterpreterMode() { return interpreterMode; }

    /**
    * Try to initialize the memory manager. 
    * Can be called many times, will initialize only once, if conditions are met.
    */
    void initMemoryManager();

    /** 
     * Create a memory allocation using the memory manager.
     */
    Value *createMemoryAllocation(Type *type, Value *size, BasicBlock *insertAtEnd);

    Module *getModule() { return module; }
  };

} // namespace stark

#endif