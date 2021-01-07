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

#include "CodeGenContext.h"
#include "CodeGenVisitor.h"

using namespace llvm;
using namespace std;

namespace stark
{

	class CodeGenVisitor;

	void CodeGenContext::declareComplexTypes()
	{
		// string
		CodeGenComplexType *stringType = new CodeGenComplexType("string", &llvmContext);
		stringType->addMember("data", Type::getInt8PtrTy(llvmContext));
		stringType->addMember("len", IntegerType::getInt64Ty(llvmContext));
		declareComplexType(stringType);
	}

	void CodeGenContext::declareComplexType(CodeGenComplexType *complexType)
	{

		complexType->declare();
		complexTypes[complexType->getName()] = complexType;
	}

	CodeGenComplexType *CodeGenContext::getComplexType(std::string name)
	{
		if (complexTypes.find(name) != complexTypes.end())
		{
			return complexTypes[name];
		}

		return NULL;
	}

	void CodeGenContext::declareLocal(CodeGenVariable *var)
	{
		CodeGenBlock *top = blocks.top();
		var->declare(top->block);
		top->locals[var->getName()] = var;
	}

	CodeGenVariable *CodeGenContext::getLocal(std::string name)
	{
		CodeGenBlock *top = blocks.top();
		if (top->locals.find(name) != top->locals.end())
		{
			return top->locals[name];
		}

		return NULL;
	}

	/* Push new block on the stack */
	void CodeGenContext::pushBlock(BasicBlock *block)
	{
		blocks.push(new CodeGenBlock());
		blocks.top()->isMergeBlock = false;
		blocks.top()->block = block;

		logger.logDebug(formatv(">> pushing block {0}.{1}", block->getParent()->getName(), block->getName()));
	}

	/* Push new block on the stack, 
 * with ability to copy local variables of the curretn block to the new block */
	void CodeGenContext::pushBlock(BasicBlock *block, bool inheritLocals)
	{
		CodeGenBlock *top = blocks.top();

		std::map<std::string, CodeGenVariable *> &l = top->locals;
		this->pushBlock(block);
		blocks.top()->locals = l;
	}

	/* Pop block from the stack */
	void CodeGenContext::popBlock()
	{
		CodeGenBlock *top = blocks.top();

		bool isMerge = top->isMergeBlock;

		logger.logDebug(formatv("<< popping block {0}.{1}", top->block->getParent()->getName(), top->block->getName()));

		blocks.pop();
		delete top;

		// If current block is a merge block : pop once again
		if (isMerge)
		{
			popBlock();
		}
	}

	/* Generate code from AST root */
	void CodeGenContext::generateCode(ASTBlock &root)
	{

		// Enable debug on code geenration
		logger.debugEnabled = true;

		logger.logDebug("generating code...");

		// Root visitor
		CodeGenVisitor visitor(this);

		// Declare complex types
		declareComplexTypes();

		// Create the top level interpreter function to call as entry
		vector<Type *> argTypes;
		FunctionType *ftype = FunctionType::get(Type::getVoidTy(llvmContext), makeArrayRef(argTypes), false);
		mainFunction = Function::Create(ftype, GlobalValue::InternalLinkage, "main", module);
		BasicBlock *bblock = BasicBlock::Create(llvmContext, "entry", mainFunction, 0);

		// Push a new variable/block context
		pushBlock(bblock);

		// Start visitor on root
		logger.logDebug(formatv("root type = {0}", typeid(root).name()));
		root.accept(&visitor);

		// No terminator detected, add a default return to the block
		if (getCurrentBlock()->getTerminator() == NULL)
		{
			logger.logDebug(formatv("not terminator on block {0}.{1}, adding one", getCurrentBlock()->getParent()->getName(), getCurrentBlock()->getName()));
			ReturnInst::Create(llvmContext, getCurrentBlock());
		}

		popBlock();

		/* Print the bytecode in a human-readable format 
	   to see if our program compiled properly
	 */
		std::cout << "Code is generated.\n";
		std::cout << "----------- DUMP -------------\n";
		module->print(llvm::errs(), nullptr);
	}

	/* Executes the AST by running the main function */
	GenericValue CodeGenContext::runCode()
	{

		logger.logDebug("running code...");
		std::string err;

		LLVMInitializeNativeTarget();
		LLVMInitializeNativeAsmPrinter();
		LLVMInitializeNativeAsmParser();
		ExecutionEngine *ee = EngineBuilder(unique_ptr<Module>(module)).setErrorStr(&err).create();
		if (!ee)
		{
			logger.logError(formatv("JIT error: {0}", err));
		}

		// TODO: pass manager here !

		ee->finalizeObject();
		vector<GenericValue> noargs;
		GenericValue v = ee->runFunction(mainFunction, noargs);
		logger.logDebug("code was run");
		return v;
	}

} // namespace stark