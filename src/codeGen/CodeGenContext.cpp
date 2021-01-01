#include "CodeGenContext.h"

#include "CodeGenVisitor.h"
#include "BuiltIn.h"

using namespace llvm;
using namespace std;

class CodeGenVisitor;

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

    // Add builtin functions 
    createPrintfFunction(*this);

    // Start visitor on root
    logger.logDebug(formatv("root type = {0}", typeid(root).name()));
    root.accept(&visitor);

	// If no return statment on the block : add one
	if (currentBlock()->getTerminator() == NULL) {
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
	ee->finalizeObject();
	vector<GenericValue> noargs;
	GenericValue v = ee->runFunction(mainFunction, noargs);
    logger.logDebug("code was run");
	return v;
}