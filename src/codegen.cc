#include "codegen.hh"

using namespace std;

void CodeGenContext::generateCode(ASTBlock& root)
{
	std::cout << "Generating code...\n";

    visitor = new CodeGenVisitor(this);
	
	// Create the top level interpreter function to call as entry
	vector<Type*> argTypes;
	FunctionType *ftype = FunctionType::get(Type::getVoidTy(MyContext), makeArrayRef(argTypes), false);
	mainFunction = Function::Create(ftype, GlobalValue::InternalLinkage, "main", module);
	BasicBlock *bblock = BasicBlock::Create(MyContext, "entry", mainFunction, 0);
	
	/* Push a new variable/block context */
	pushBlock(bblock);
	// TODO
    //root.codeGen(*this); /* emit bytecode for the toplevel block */
    //std::cout << "Root type = " << typeid(root).name() << std::endl;
    visitor->visit(&root);
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

    delete visitor;
    visitor = NULL;
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

void CodeGenVisitor::visit(ASTExpression *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTInteger *node) {
    // TODO
    std::cout << "Creating integer: " << node->value << endl;

	//return ConstantInt::get(Type::getInt64Ty(MyContext), value, true);
}

void CodeGenVisitor::visit(ASTDouble *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTIdentifier *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTBlock *node) {
    // TODO
    ASTStatementList::const_iterator it;
	Value *last = NULL;

	for (it = node->statements.begin(); it != node->statements.end(); it++) {
		std::cout << "Generating code for " << typeid(**it).name() << endl;
        (**it).accept(this);
		//last = (**it).codeGen(context);
	}
	std::cout << "Creating block" << endl;
	//return last;
}

void CodeGenVisitor::visit(ASTAssignment *node) {
    // TODO
    std::cout << "Creating assignment for " << node->lhs.name << endl;
	/*if (context.locals().find(lhs.name) == context.locals().end()) {
		std::cerr << "undeclared variable " << lhs.name << endl;
		return NULL;
	}
	return new StoreInst(rhs.codeGen(context), context.locals()[lhs.name], false, context.currentBlock());*/
}

void CodeGenVisitor::visit(ASTExpressionStatement *node) {
    // TODO
}

void CodeGenVisitor::visit(ASTVariableDeclaration *node) {
    // TODO
    std::cout << "Creating variable declaration " << node->type.name << " " << node->id.name << endl;
    //AllocaInst *alloc = Builder.CreateAlloca (typeOf(node->type), nullptr, node->id.name);
	/*context->locals()[node->id.name] = alloc;
	if (node->assignmentExpr != NULL) {
        std::cout << ">>> assign" << endl;
		ASTAssignment assn(node->id, *node->assignmentExpr);
        //this->visit(&assn);
        assn.accept(this);
		//assn.codeGen(context);
	}*/
	//return alloc;

    // Use builder
    //  AllocaInst *CreateAlloca(Type *Ty, unsigned AddrSpace, Value *ArraySize = nullptr, const Twine &Name = "")
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
		//(**it).codeGen(context);
        (**it).accept(this);
		
		argumentValue = &*argsValues++;
		argumentValue->setName((*it)->id.name.c_str());
		StoreInst *inst = new StoreInst(argumentValue, context->locals()[(*it)->id.name], false, bblock);
	}
	
	//block.codeGen(context);
    node->block.accept(this);
	ReturnInst::Create(MyContext, context->getCurrentReturnValue(), bblock);

	context->popBlock();
	std::cout << "Creating function: " << node->id.name << endl;
	//return function;
}

void CodeGenVisitor::visit(ASTMethodCall *node) {
    
    // TODO
    
}


