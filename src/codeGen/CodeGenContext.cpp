#include "CodeGenContext.h"
#include "CodeGenVisitor.h"

using namespace llvm;
using namespace std;

class CodeGenVisitor;

/* Push new block on the stack */
void CodeGenContext::pushBlock(BasicBlock *block) { 
	blocks.push(new CodeGenBlock()); 
	blocks.top()->isMergeBlock = false;
	blocks.top()->block = block; 

	logger.logDebug(formatv(">> pushing block {0}.{1}", block->getParent()->getName(), block->getName()));
}

/* Push new block on the stack, 
 * with ability to copy local variables of the curretn block to the new block */
void CodeGenContext::pushBlock(BasicBlock *block, bool inheritLocals) { 
	std::map<std::string, Value*>& l = this->locals(); 
	this->pushBlock(block); 
	blocks.top()->locals = l; 
}

/* Pop block from the stack */
void CodeGenContext::popBlock() { 
	CodeGenBlock *top = blocks.top();

	bool isMerge = top->isMergeBlock;

	logger.logDebug(formatv("<< popping block {0}.{1}", top->block->getParent()->getName(), top->block->getName()));

	blocks.pop(); 
	delete top; 
	
	// If current block is a merge block : pop once again
	if (isMerge) {
		popBlock();
	}
}

/* Generate code from AST root */
void CodeGenContext::generateCode(ASTBlock& root) {

    // Enable debug on code geenration
    logger.debugEnabled = true;

    logger.logDebug("generating code...");

    // Root visitor
    CodeGenVisitor visitor(this);

	// Create the top level interpreter function to call as entry
	vector<Type*> argTypes;
	FunctionType *ftype = FunctionType::get(Type::getVoidTy(MyContext), makeArrayRef(argTypes), false);
	mainFunction = Function::Create(ftype, GlobalValue::InternalLinkage, "main", module);
	BasicBlock *bblock = BasicBlock::Create(MyContext, "entry", mainFunction, 0);
	
	// Push a new variable/block context
	pushBlock(bblock);

    // Start visitor on root
    logger.logDebug(formatv("root type = {0}", typeid(root).name()));
    root.accept(&visitor);

	// No terminator detected, add a default return to the block
    if (currentBlock()->getTerminator() == NULL) {
		logger.logDebug(formatv("not terminator on block {0}.{1}, adding one", currentBlock()->getParent()->getName(), currentBlock()->getName()));
        ReturnInst::Create(MyContext, currentBlock());
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
GenericValue CodeGenContext::runCode() {

	logger.logDebug("running code...");
    std::string err;
    
    LLVMInitializeNativeTarget();
	LLVMInitializeNativeAsmPrinter();
	LLVMInitializeNativeAsmParser();
	ExecutionEngine *ee = EngineBuilder( unique_ptr<Module>(module) ).setErrorStr(&err).create();
    if (!ee) {
       logger.logError(formatv("JIT error: {0}", err));
    }

	// TODO: pass manager here !


	ee->finalizeObject();
	vector<GenericValue> noargs;
	GenericValue v = ee->runFunction(mainFunction, noargs);
    logger.logDebug("code was run");
	return v;
}