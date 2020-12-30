#include "CodeGen.h"
#include "BuiltIn.h"

using namespace std;

/* Returns an LLVM type based on the identifier */
static Type *typeOf(const ASTIdentifier& type) {
	if (type.name.compare("int") == 0) {
		return Type::getInt64Ty(MyContext);
	}
	else if (type.name.compare("double") == 0) {
		return Type::getDoubleTy(MyContext);
	}
    else if (type.name.compare("string") == 0) {
		return Type::getInt8PtrTy(MyContext);
	}
	return Type::getVoidTy(MyContext);
}

/* Logger */

void CodeGenLogger::logError(std::string message) {
    std::string outputMessage = formatv("ERROR: {0}", message);
    std::cerr << outputMessage << endl;
    // Error if fatal for compiler: exiting
    exit(1);
}

void CodeGenLogger::logWarn(std::string message) {
    std::string outputMessage = formatv("WARNING: {0}", message);
    std::cerr << outputMessage << endl;
}

void CodeGenLogger::logDebug(std::string message) {
    if (this->debugEnabled) {
        std::string outputMessage = formatv("DEBUG: {0}", message);
        std::cerr << outputMessage << endl;
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

    // Add builtin functions 
    createPrintfFunction(*this);

    // Start visitor on root
    logger.logDebug(formatv("root type = {0}", typeid(root).name()));
    root.accept(&visitor);

	ReturnInst::Create(MyContext, bblock);
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

/* Code generation */

void CodeGenVisitor::visit(ASTInteger *node) {
    
    context->logger.logDebug(formatv("creating integer {0}", node->value));
    this->result = ConstantInt::get(Type::getInt64Ty(MyContext), node->value, true);
}

void CodeGenVisitor::visit(ASTDouble *node) {
    
    context->logger.logDebug(formatv("creating double {0}", node->value));
	this->result = ConstantFP::get(Type::getDoubleTy(MyContext), node->value);
}

void CodeGenVisitor::visit(ASTString *node) {
    
    context->logger.logDebug(formatv("creating string {0}", node->value));

    std::string utf8string = node->value;
    // Create constant vector of the string size
    std::vector<llvm::Constant *> chars(utf8string.size() + 1);
    // Set each char of the string in the vector
    for(unsigned int i = 0; i < utf8string.size(); i++) chars[i] = ConstantInt::get(Type::getInt8Ty(MyContext), utf8string[i]);
    // Add string terminator
    chars[utf8string.size()] = ConstantInt::get(Type::getInt8Ty(MyContext), '\0');

    // Set value as global variable
    auto init = ConstantArray::get(ArrayType::get(Type::getInt8Ty(MyContext), chars.size()), chars);
    GlobalVariable * v = new GlobalVariable(*context->module, init->getType(), true, GlobalVariable::ExternalLinkage, init, utf8string);
    // Return pointer? on the string
    this->result = ConstantExpr::getBitCast(v, Type::getInt8Ty(MyContext)->getPointerTo());
}

void CodeGenVisitor::visit(ASTIdentifier *node) {
    
    context->logger.logDebug(formatv("creating identifier reference {0}", node->name));
	if (context->locals().find(node->name) == context->locals().end()) {
        context->logger.logError(formatv("undeclared identifier {0}", node->name));
	}

    // Wrong type here !!!! it moved to ptr on double !!!
    std::string type_str;
    llvm::raw_string_ostream rso(type_str);
    context->locals()[node->name]->getType()->getPointerElementType()->print(rso);
    std::cout<< rso.str() << endl;

    // Note : variables are stored as pointers into the symbol table
    // So, when we load the value of a variable, whe must use ->getType()->getPointerElementType()
    // From the variable type to get the real value (and not the pointer on that value)
	this->result = new LoadInst(context->locals()[node->name]->getType()->getPointerElementType(), context->locals()[node->name], "", false, context->currentBlock());
}

void CodeGenVisitor::visit(ASTBlock *node) {
    
    ASTStatementList::const_iterator it;
	Value *last = NULL;

	for (it = node->statements.begin(); it != node->statements.end(); it++) {
        context->logger.logDebug(formatv("generating code for {0}", typeid(**it).name()));
        CodeGenVisitor v(context);
        (**it).accept(&v);
		last = v.result;
	}
    context->logger.logDebug("creating block");
	this->result = last;
}

void CodeGenVisitor::visit(ASTAssignment *node) {
    
    context->logger.logDebug(formatv("creating assignment for {0}", node->lhs.name));
	if (context->locals().find(node->lhs.name) == context->locals().end()) {
        context->logger.logError(formatv("undeclared variable {0}", node->lhs.name));
	}
    CodeGenVisitor v(context);
    node->rhs.accept(&v);

	this->result = new StoreInst(v.result, context->locals()[node->lhs.name], false, context->currentBlock());
}

void CodeGenVisitor::visit(ASTExpressionStatement *node) {
    
    context->logger.logDebug(formatv("generating code for {0}", typeid(node->expression).name()));
    CodeGenVisitor v(context);
    node->expression.accept(&v);
    this->result = v.result;
}


void CodeGenVisitor::visit(ASTVariableDeclaration *node) {

    context->logger.logDebug(formatv("creating variable declaration {0} {1}", node->type.name, node->id.name));
    AllocaInst *alloc = new AllocaInst(typeOf(node->type), 0, node->id.name.c_str(), context->currentBlock());
	context->locals()[node->id.name] = alloc;
    
	if (node->assignmentExpr != NULL) {
        ASTAssignment assn(node->id, *(node->assignmentExpr));
        CodeGenVisitor v(context);
        assn.accept(&v);
	}
    this->result = alloc;
}

void CodeGenVisitor::visit(ASTFunctionDeclaration *node) {
    
    context->logger.logDebug(formatv("creating function declaration for {0}", node->id.name));
    vector<Type*> argTypes;
	ASTVariableList::const_iterator it;
	for (it = node->arguments.begin(); it != node->arguments.end(); it++) {
		argTypes.push_back(typeOf((**it).type));
	}
	FunctionType *ftype = FunctionType::get(typeOf(node->type), makeArrayRef(argTypes), false);
	Function *function = Function::Create(ftype, GlobalValue::InternalLinkage, node->id.name.c_str(), context->module);
	BasicBlock *bblock = BasicBlock::Create(MyContext, "entry", function, 0);

	context->pushBlock(bblock);

	Function::arg_iterator argsValues = function->arg_begin();
    Value* argumentValue;

	for (it = node->arguments.begin(); it != node->arguments.end(); it++) {
        CodeGenVisitor v(context);
        (**it).accept(&v);
		
		argumentValue = &*argsValues++;
		argumentValue->setName((*it)->id.name.c_str());
		StoreInst *inst = new StoreInst(argumentValue, context->locals()[(*it)->id.name], false, bblock);
	}
	
    CodeGenVisitor v(context);
    node->block.accept(&v);
	ReturnInst::Create(MyContext, context->getCurrentReturnValue(), bblock);

	context->popBlock();
    context->logger.logDebug(formatv("creating function {0}", node->id.name));
	this->result = function;
}

void CodeGenVisitor::visit(ASTMethodCall *node) {
    
    Function *function = context->module->getFunction(node->id.name.c_str());
	if (function == NULL) {
        context->logger.logError(formatv("undeclared function {0}", node->id.name));
	}
	std::vector<Value*> args;
	ASTExpressionList::const_iterator it;
	for (it = node->arguments.begin(); it != node->arguments.end(); it++) {
        CodeGenVisitor v(context);
        (**it).accept(&v);
        args.push_back(v.result);
	}
	CallInst *call = CallInst::Create(function, makeArrayRef(args), "", context->currentBlock());
    context->logger.logDebug(formatv("creating method call {0}", node->id.name));
	this->result = call;
}

void CodeGenVisitor::visit(ASTExternDeclaration *node) {

    context->logger.logDebug(formatv("creating extern declaration for {0}", node->id.name));
    vector<Type*> argTypes;
    ASTVariableList::const_iterator it;
    for (it = node->arguments.begin(); it != node->arguments.end(); it++) {
        argTypes.push_back(typeOf((**it).type));
    }
    FunctionType *ftype = FunctionType::get(typeOf(node->type), makeArrayRef(argTypes), false);
    Function *function = Function::Create(ftype, GlobalValue::ExternalLinkage, node->id.name.c_str(), context->module);
    this->result = function;
}

void CodeGenVisitor::visit(ASTReturnStatement *node) {
    
    context->logger.logDebug(formatv("generating return code {0}", typeid(node->expression).name()));
    CodeGenVisitor v(context);
    node->expression.accept(&v);
	Value *returnValue = v.result;
	context->setCurrentReturnValue(returnValue);
	this->result = returnValue;
}

void CodeGenVisitor::visit(ASTBinaryOperator *node) {
    
    context->logger.logDebug(formatv("creating binary operation {0}", node->op));
    
    CodeGenVisitor vl(context);
    node->lhs.accept(&vl);
    CodeGenVisitor vr(context);
    node->rhs.accept(&vr);

	Instruction::BinaryOps instr;
    if (node->op == "+") {
        instr = vl.result->getType()->isDoubleTy() ? Instruction::FAdd : Instruction::Add;
    } else if (node->op == "-") {
        instr = vl.result->getType()->isDoubleTy() ? Instruction::FSub : Instruction::Sub;
    } else if (node->op == "*") {
        instr = vl.result->getType()->isDoubleTy() ? Instruction::FMul : Instruction::Mul;
    } else if (node->op == "/") {
        instr = Instruction::SDiv;
    }

	this->result = BinaryOperator::Create(instr, vl.result, vr.result, "", context->currentBlock());
    
}

