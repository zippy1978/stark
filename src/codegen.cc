#include "codegen.hh"
#include "builtin.hh"

using namespace std;

// TODO : add proper error function
void CodeGenContext::generateCode(ASTBlock& root)
{
	std::cout << "Generating code...\n";

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

    std::cout << "Root type = " << typeid(root).name() << std::endl;
    root.accept(&visitor);

	ReturnInst::Create(MyContext, bblock);
	popBlock();
	
	/* Print the bytecode in a human-readable format 
	   to see if our program compiled properly
	 */
	std::cout << "Code is generated.\n";
    std::cout << "----------- DUMP -------------\n";
	module->print(llvm::errs(), nullptr);

    // Builtin ???
	/*legacy::PassManager pm;
	pm.add(createPrintModulePass(outs()));
	pm.run(*module);*/

}

/* Executes the AST by running the main function */
GenericValue CodeGenContext::runCode() {
	std::cout << "Running code...\n";
    std::string err;
    
    LLVMInitializeNativeTarget();
	LLVMInitializeNativeAsmPrinter();
	LLVMInitializeNativeAsmParser();

	ExecutionEngine *ee = EngineBuilder( unique_ptr<Module>(module) ).setErrorStr(&err).create();
    if (!ee) {
       std::cout << "JIT Error: " << err << std::endl;
       exit(-1);
    }
	ee->finalizeObject();
	vector<GenericValue> noargs;
	GenericValue v = ee->runFunction(mainFunction, noargs);
	std::cout << "Code was run.\n";
	return v;
}

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

Value *logError(const char *message) {
  std::cerr << message << endl;
  return nullptr;
}

/* Code generation */

void CodeGenVisitor::visit(ASTInteger *node) {
    
    std::cout << "Creating integer: " << node->value << endl;
    this->result = ConstantInt::get(Type::getInt64Ty(MyContext), node->value, true);
}

void CodeGenVisitor::visit(ASTDouble *node) {
    
    std::cout << "Creating double: " << node->value << endl;
	this->result = ConstantFP::get(Type::getDoubleTy(MyContext), node->value);
}

void CodeGenVisitor::visit(ASTIdentifier *node) {
    // TODO
    std::cout << "Creating identifier reference: " << node->name << endl;
	if (context->locals().find(node->name) == context->locals().end()) {
		std::cerr << "undeclared variable " << node->name << endl;
	}
	this->result = new LoadInst(context->locals()[node->name]->getType(), context->locals()[node->name], "", false, context->currentBlock());
}

void CodeGenVisitor::visit(ASTBlock *node) {
    
    ASTStatementList::const_iterator it;
	Value *last = NULL;

	for (it = node->statements.begin(); it != node->statements.end(); it++) {
		std::cout << "Generating code for " << typeid(**it).name() << endl;
        CodeGenVisitor v(context);
        (**it).accept(&v);
		last = v.result;
	}
	std::cout << "Creating block" << endl;
	this->result = last;
}

void CodeGenVisitor::visit(ASTAssignment *node) {
    
    std::cout << "Creating assignment for " << node->lhs.name << endl;
	if (context->locals().find(node->lhs.name) == context->locals().end()) {
		std::cerr << "undeclared variable " << node->lhs.name << endl;
	}
    CodeGenVisitor v(context);
    node->rhs.accept(&v);
	this->result = new StoreInst(v.result, context->locals()[node->lhs.name], false, context->currentBlock());
}

void CodeGenVisitor::visit(ASTExpressionStatement *node) {
    
    std::cout << "Generating code for " << typeid(node->expression).name() << endl;
    CodeGenVisitor v(context);
    node->expression.accept(&v);
    this->result = v.result;
}


void CodeGenVisitor::visit(ASTVariableDeclaration *node) {

    std::cout << "Creating variable declaration " << node->type.name << " " << node->id.name << endl;
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
	
	//block.codeGen(context);
    CodeGenVisitor v(context);
    node->block.accept(&v);
	ReturnInst::Create(MyContext, context->getCurrentReturnValue(), bblock);

	context->popBlock();
	std::cout << "Creating function: " << node->id.name << endl;
	this->result = function;
}

void CodeGenVisitor::visit(ASTMethodCall *node) {
    
    Function *function = context->module->getFunction(node->id.name.c_str());
	if (function == NULL) {
		std::cerr << "no such function " << node->id.name << endl;
	}
	std::vector<Value*> args;
	ASTExpressionList::const_iterator it;
	for (it = node->arguments.begin(); it != node->arguments.end(); it++) {
        CodeGenVisitor v(context);
        (**it).accept(&v);
        args.push_back(v.result);
	}
	CallInst *call = CallInst::Create(function, makeArrayRef(args), "", context->currentBlock());
	std::cout << "Creating method call: " << node->id.name << endl;
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
    
    std::cout << "Generating return code for " << typeid(node->expression).name() << endl;
    CodeGenVisitor v(context);
    node->expression.accept(&v);
	Value *returnValue = v.result;
	context->setCurrentReturnValue(returnValue);
	this->result = returnValue;
}

void CodeGenVisitor::visit(ASTBinaryOperator *node) {
    
    std::cout << "Creating binary operation " << node->op << endl;
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

