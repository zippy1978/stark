#include "CodeGenVisitor.h"

using namespace std;

/* Returns an LLVM type based on the identifier */
static Type *typeOf(const ASTIdentifier& type) {
	if (type.name.compare("int") == 0) {
		return Type::getInt64Ty(MyContext);
	}
    else if (type.name.compare("bool") == 0) {
		return Type::getInt1Ty(MyContext);
	}
	else if (type.name.compare("double") == 0) {
		return Type::getDoubleTy(MyContext);
	}
    else if (type.name.compare("string") == 0) {
		return Type::getInt8PtrTy(MyContext);
	}
	return Type::getVoidTy(MyContext);
}

/* Code generation */

void CodeGenVisitor::visit(ASTInteger *node) {
    
    context->logger.logDebug(formatv("creating integer {0}", node->value));
    this->result = ConstantInt::get(Type::getInt64Ty(MyContext), node->value, true);
}

void CodeGenVisitor::visit(ASTBoolean *node) {
    context->logger.logDebug(formatv("creating boolean {0}", node->value));
    this->result = ConstantInt::get(Type::Type::getInt1Ty(MyContext), node->value, true);
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

    if (context->locals().find(node->id.name) != context->locals().end()) {
        context->logger.logError(formatv("variable {0} already declared", node->id.name));
	}

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

    if (context->module->getFunction(node->id.name.c_str()) != NULL) {
        context->logger.logError(formatv("function {0} already declared", node->id.name));
	}

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

    Builder.SetInsertPoint(context->currentBlock());

    bool isDouble = vl.result->getType()->isDoubleTy();
	Instruction::BinaryOps instr;
    switch (node->op) {
        case ADD:
            instr = isDouble ? Instruction::FAdd : Instruction::Add;
            break;
        case SUB:
            instr = isDouble ? Instruction::FSub : Instruction::Sub;
            break;
        case MUL:
            instr = isDouble ? Instruction::FMul : Instruction::Mul;
            break;
        case DIV:
            instr = isDouble ? Instruction::FDiv : Instruction::SDiv;
            break;
        case OR:
            instr = Instruction::Or;
            break;
        case AND:
            instr = Instruction::And;
            break;
    }

    this->result = Builder.CreateBinOp(instr, vl.result, vr.result, "");
    
}

void CodeGenVisitor::visit(ASTComparison *node) {
    
    context->logger.logDebug(formatv("creating comparison {0}", node->op));
    
    CodeGenVisitor vl(context);
    node->lhs.accept(&vl);
    CodeGenVisitor vr(context);
    node->rhs.accept(&vr);

    Builder.SetInsertPoint(context->currentBlock());

    bool isDouble = vl.result->getType()->isDoubleTy();
	Instruction::BinaryOps instr;
    switch (node->op) {
        case EQ:
            this->result = vl.result->getType()->isDoubleTy() ? Builder.CreateFCmpOEQ(vl.result, vr.result, "") : Builder.CreateICmpEQ(vl.result, vr.result, "");
            break;
        case NE:
            this->result = vl.result->getType()->isDoubleTy() ? Builder.CreateFCmpONE(vl.result, vr.result, "") : Builder.CreateICmpNE(vl.result, vr.result, "");
            break;
        case LT:
            this->result = vl.result->getType()->isDoubleTy() ? Builder.CreateFCmpOLT(vl.result, vr.result, "") : Builder.CreateICmpSLT(vl.result, vr.result, "");
            break;
        case LE:
            this->result = vl.result->getType()->isDoubleTy() ? Builder.CreateFCmpOLE(vl.result, vr.result, "") : Builder.CreateICmpSLE(vl.result, vr.result, "");
            break;
        case GT:
            this->result = vl.result->getType()->isDoubleTy() ? Builder.CreateFCmpOGT(vl.result, vr.result, "") : Builder.CreateICmpSGT(vl.result, vr.result, "");
            break;
        case GE:
            this->result = vl.result->getType()->isDoubleTy() ? Builder.CreateFCmpOGE(vl.result, vr.result, "") : Builder.CreateICmpSGE(vl.result, vr.result, "");
            break;
    }
    
}