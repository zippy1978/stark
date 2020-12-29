#include "codegen.hh"
#include "builtin.hh"

using namespace std;

/* Returns an LLVM type based on the identifier */
static Type *typeOf(const ASTIdentifier& type) 
{
	if (type.name.compare("int") == 0) {
		return Type::getInt64Ty(MyContext);
	}
	else if (type.name.compare("double") == 0) {
		return Type::getDoubleTy(MyContext);
	}
	return Type::getVoidTy(MyContext);
}

/* Logger */

void CodeGenLogger::logError(std::string message) {
    std::string outputMessage = formatv("ERROR: {0}", message);
    std::cerr << outputMessage << endl;
    // Error if fatal for compiler: exiting
    exit(-1);
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

void CodeGenVisitor::visit(ASTIdentifier *node) {
    
    context->logger.logDebug(formatv("creating identifier reference {0}", node->name));
	if (context->locals().find(node->name) == context->locals().end()) {
        context->logger.logError(formatv("undeclared identifier {0}", node->name));
	}
	this->result = new LoadInst(context->locals()[node->name]->getType(), context->locals()[node->name], "", false, context->currentBlock());
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
	Instruction::BinaryOps instr;
    if (node->op == "+") {
        instr = Instruction::Add;
    } else if (node->op == "-") {
        instr = Instruction::Sub;
    } else if (node->op == "*") {
        instr = Instruction::Mul;
    } else if (node->op == "/") {
        instr = Instruction::SDiv;
    }

    CodeGenVisitor vl(context);
    node->lhs.accept(&vl);
    CodeGenVisitor vr(context);
    node->rhs.accept(&vr);
	this->result = BinaryOperator::Create(instr, vl.result, vr.result, "", context->currentBlock());
    
}

