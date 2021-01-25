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
#include <llvm/Bitcode/BitcodeWriter.h>
// This is the interpreter implementation
#include <llvm/ExecutionEngine/MCJIT.h>

#include "CodeGenContext.h"
#include "CodeGenVisitor.h"
#include "../runtime/Runtime.h"
#include "../util/Util.h"

using namespace llvm;
using namespace std;

namespace stark
{

	class CodeGenVisitor;

	void CodeGenContext::declareComplexTypes()
	{
		// string
		CodeGenComplexType *stringType = new CodeGenComplexType("string", this);
		stringType->addMember("data", "-", Type::getInt8PtrTy(llvmContext));
		stringType->addMember("len", "int", IntegerType::getInt64Ty(llvmContext));
		declareComplexType(stringType);
	}

	Type *CodeGenContext::getType(std::string typeName)
	{
		// Primary types
		if (typeName.compare("int") == 0)
		{
			return Type::getInt64Ty(llvmContext);
		}
		else if (typeName.compare("bool") == 0)
		{
			return Type::getInt1Ty(llvmContext);
		}
		else if (typeName.compare("double") == 0)
		{
			return Type::getDoubleTy(llvmContext);
		}
		else if (typeName.compare("void") == 0)
		{
			return Type::getVoidTy(llvmContext);
		}

		// Complex types
		CodeGenComplexType *complexType = getComplexType(typeName);
		if (complexType != NULL)
		{
			return complexType->getType();
		}

		// Not found
		return NULL;
	}

	std::string CodeGenContext::getTypeName(Type *type)
	{

		std::string typeStr;
		llvm::raw_string_ostream rso(typeStr);
		type->print(rso);
		rso.flush();
		//std::string llvmTypeName = formatv("{0}", rso.str().c_str());
		std::string llvmTypeName = rso.str();

		// Strip type name to get the name only
		// Case adressed here :
		// %trooper = type { %string, i64, %ship } is changed to trooper
		if (llvmTypeName.rfind("%", 0) == 0)
		{
			llvmTypeName = llvmTypeName.erase(0, 1);
			std::vector<std::string> nameParts = split(llvmTypeName, ' ');
			llvmTypeName = *nameParts.begin();
		}

		if (llvmTypeName.compare("i64") == 0)
		{
			return "int";
		}
		else if (llvmTypeName.compare("i1") == 0)
		{
			return "bool";
		}
		else
		{
			return llvmTypeName;
		}
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

	CodeGenComplexType *CodeGenContext::getArrayComplexType(std::string typeName)
	{

		// First : try to find the array type (if already declared)
		CodeGenComplexType *arrayComplexType = NULL;
		if (arrayComplexTypes.find(typeName) != arrayComplexTypes.end())
		{
			arrayComplexType = arrayComplexTypes[typeName];
		}

		// If not found : declare it
		if (arrayComplexType == NULL)
		{

			CodeGenComplexType *arrayType = new CodeGenComplexType(formatv("array.{0}", typeName), this, true);
			arrayType->addMember("elements", typeName, getType(typeName)->getPointerTo());
			arrayType->addMember("len", "int", IntegerType::getInt64Ty(llvmContext));
			arrayType->declare();
			arrayComplexType = arrayType;
			arrayComplexTypes[typeName] = arrayType;
		}

		return arrayComplexType;
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

	/* Push new block on the stack, with ability to copy local variables of the curretn block to the new block */
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

		// Configure logger
		logger.debugEnabled = this->debugEnabled;
		logger.setFilename(filename);

		logger.logDebug("generating code...");

		// Root visitor
		CodeGenVisitor visitor(this);

		// Declare complex types
		declareComplexTypes();

		if (this->interpreterMode)
		{
			// Create the top level interpreter function to call as entry
			vector<Type *> argTypes;
			argTypes.push_back(getArrayComplexType("string")->getType());
			FunctionType *ftype = FunctionType::get(Type::getInt32Ty(llvmContext), makeArrayRef(argTypes), false);
			mainFunction = Function::Create(ftype, GlobalValue::InternalLinkage, "main", module);
			BasicBlock *bblock = BasicBlock::Create(llvmContext, "entry", mainFunction, 0);

			// Push a new variable/block context
			pushBlock(bblock);

			CodeGenVariable *argsVar = new CodeGenVariable("args", "string", true, getArrayComplexType("string")->getType());
			declareLocal(argsVar);

			IRBuilder<> Builder(llvmContext);
			Builder.SetInsertPoint(getCurrentBlock());

			// Get argc and argv values
			Function::arg_iterator argsValues = mainFunction->arg_begin();
			Value *argsValue = &*argsValues++;
			new StoreInst(argsValue, argsVar->getValue(), false, getCurrentBlock());

			// Start visitor on root
			logger.logDebug(formatv("root type = {0}", typeid(root).name()));
			root.accept(&visitor);

			// No return provided on main function, add a default return to the block (with 0 return)
			if (this->getReturnValue() != NULL)
			{
				ReturnInst::Create(llvmContext, this->getReturnValue(), getCurrentBlock());
			}
			else
			{
				// If no return : return 0
				logger.logDebug(formatv("not return on block {0}.{1}, adding one", getCurrentBlock()->getParent()->getName(), getCurrentBlock()->getName()));
				ReturnInst::Create(llvmContext, ConstantInt::get(Type::getInt32Ty(llvmContext), 0, true), getCurrentBlock());
			}

			popBlock();
		}
		else
		{
			// Raw mode (no main function is generated)

			// Start visitor on root
			logger.logDebug(formatv("root type = {0}", typeid(root).name()));
			root.accept(&visitor);
		}

		/* Print the IR in a human-readable format to see if our program compiled properly */

		if (this->debugEnabled)
		{
			std::cout << "Code is generated.\n";
			std::cout << "----------- DUMP -------------\n";
			module->print(llvm::errs(), nullptr);
		}
	}

	void CodeGenContext::writeCode(std::string filename)
	{
		// TODO : hande error
		std::error_code errorCode;
		//raw_ostream output = outs();
		raw_fd_ostream output(filename, errorCode);
		WriteBitcodeToFile(*module, output);
	}

	/* Executes the AST by running the main function */
	int CodeGenContext::runCode(int argc, char *argv[])
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

		// Build stark string array to pass to main function
		stark::array_t args;
		args.len = argc;
		stark::string_t *elements = (stark::string_t *)malloc(sizeof(stark::string_t) * argc);
		for (int i = 0; i < argc; i++)
		{
			stark::string_t s;
			s.len = strlen(argv[i]);
			s.data = (char *)malloc(sizeof(char) * s.len);
			strcpy(s.data, argv[i]);
			elements[i] = s;
		}
		args.elements = elements;

		// Call main function
		int (*main_func)(stark::array_t) = (int (*)(stark::array_t))ee->getFunctionAddress("main");
		int retValue = main_func(args);

		logger.logDebug(formatv("code was run, return code is {0}", retValue));
		return retValue;
	}

} // namespace stark