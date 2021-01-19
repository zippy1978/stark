#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Support/FormatVariadic.h>

#include "CodeGenVisitor.h"

using namespace std;
using namespace stark;

namespace stark
{

    /*
    static void printDebugType(Value *value)
    {
        std::string typeStr;
        llvm::raw_string_ostream rso(typeStr);
        value->getType()->print(rso);
        std::string llvmTypeName = rso.str();
        cout << ">>>>>> " << llvmTypeName << endl;
    }

    static void printDebugValue(Value *value)
    {
        std::string typeStr;
        llvm::raw_string_ostream rso(typeStr);
        value->print(rso);
        std::string llvmTypeName = rso.str();
        cout << ">>>>>> " << llvmTypeName << endl;
    }

    static void printIdent(ASTIdentifier *ident)
    {

        cout << ident->name;
        if (ident->index != NULL)
        {
            cout << "[expr]";
        }

        while (ident->member != NULL)
        {
            cout << "." << ident->member->name;
            if (ident->member->index != NULL)
            {
                cout << "[expr]";
            }
            ident = ident->member;
        }

        cout << endl;
    }*/

    /**
     * Get variable as llvm:Value for a complex type from an identifier.
     * Recurse to get the end value in case of a nested identifier.
     */
    static Value *getComplexTypeMemberValue(CodeGenComplexType *complexType, Value *varValue, ASTIdentifier *identifier, CodeGenContext *context)
    {
   
        IRBuilder<> Builder(context->llvmContext);
        Builder.SetInsertPoint(context->getCurrentBlock());

        // Array case : must point to index element
        if (identifier->index != NULL)
        {

            if (!complexType->isArray())
            {
                context->logger.logError(formatv("{0} is not an array type", complexType->getName()));
            }

            context->logger.logDebug("resolving array index");

            // Evaluate index expression
            CodeGenVisitor vi(context);
            identifier->index->accept(&vi);
            Value *indexExprAsInt32 = Builder.CreateIntCast(vi.result, Type::getInt32Ty(context->llvmContext), false);

            // Get elements member
            CodeGenComplexTypeMember *elementsMember = complexType->getMember("elements");

           
            // Get elements pointer (and load in between 2 GEPs !)
            Value *elementsPointer = Builder.CreateStructGEP(varValue, elementsMember->position, "elementptrs");
            
            // This load seems weird !!!
            varValue = Builder.CreateLoad(elementsPointer);
            
            // Get position in elements pointer
            varValue = Builder.CreateInBoundsGEP(varValue, indexExprAsInt32);

            // Set current complex type as array element type
            complexType = elementsMember->array ? context->getArrayComplexType(elementsMember->typeName) : context->getComplexType(elementsMember->typeName);

            // Remove index to be treated as normal complex type on next call
            ASTIdentifierList memberIds;
            memberIds.push_back(identifier->member);
            ASTIdentifier newId(elementsMember->typeName, NULL, &memberIds);

            // Recurse
            return getComplexTypeMemberValue(complexType, varValue, &newId, context);
        }
        else if (identifier->member != NULL)
        {
            context->logger.logDebug(formatv("resolving value for {0} in complex type {1}", identifier->member->name, complexType->getName()));

            CodeGenComplexTypeMember *complexTypeMember = complexType->getMember(identifier->member->name);
            if (complexTypeMember == NULL)
            {
                context->logger.logError(formatv("no member named {0} for type {1}", identifier->member->name, complexType->getName()));
            }

            // Load member value
            varValue = Builder.CreateStructGEP(varValue, complexTypeMember->position, "memberptr");

            // Is member a complex type ?
            // Handle special type lookup for array
            complexType = complexTypeMember->array ? context->getArrayComplexType(complexTypeMember->typeName) : context->getComplexType(complexTypeMember->typeName);

            // Recurse
            return getComplexTypeMemberValue(complexType, varValue, identifier->member, context);
        }
        else
        {
            return varValue;
        }
    }

    /**
     * Returns an LLVM type based on an identifier.
     * First look for primatry types.
     * Then look for complex types.
     * If no type found, returns void type.
     */
    static Type *typeOf(const ASTIdentifier &type, CodeGenContext *context)
    {
        return context->getType(type.name);
    }

    // Code generation

    void CodeGenVisitor::visit(ASTInteger *node)
    {

        context->logger.logDebug(formatv("creating integer {0}", node->value));
        this->result = ConstantInt::get(Type::getInt64Ty(context->llvmContext), node->value, true);
    }

    void CodeGenVisitor::visit(ASTBoolean *node)
    {
        context->logger.logDebug(formatv("creating boolean {0}", node->value));
        this->result = ConstantInt::get(Type::Type::getInt1Ty(context->llvmContext), node->value, true);
    }

    void CodeGenVisitor::visit(ASTDouble *node)
    {

        context->logger.logDebug(formatv("creating double {0}", node->value));
        this->result = ConstantFP::get(Type::getDoubleTy(context->llvmContext), node->value);
    }

    void CodeGenVisitor::visit(ASTString *node)
    {

        context->logger.logDebug(formatv("creating string {0}", node->value));

        std::string utf8string = node->value;
        // Create constant vector of the string size
        std::vector<llvm::Constant *> chars(utf8string.size() + 1);
        // Set each char of the string in the vector
        for (unsigned int i = 0; i < utf8string.size(); i++)
            chars[i] = ConstantInt::get(Type::getInt8Ty(context->llvmContext), utf8string[i]);
        // Add string terminator
        chars[utf8string.size()] = ConstantInt::get(Type::getInt8Ty(context->llvmContext), '\0');

        // Set value as global variable
        auto init = ConstantArray::get(ArrayType::get(Type::getInt8Ty(context->llvmContext), chars.size()), chars);
        GlobalVariable *v = new GlobalVariable(*context->module, init->getType(), true, GlobalVariable::ExternalLinkage, init, utf8string);

        // Build and return string instance
        // TODO : use a builder on the complex type to generate the value with named parameters map
        Constant *values[] = {v, ConstantInt::get(Type::getInt64Ty(context->llvmContext), utf8string.size(), true)};
        this->result = ConstantStruct::get(context->getComplexType("string")->getType(), values);
    }

    void CodeGenVisitor::visit(ASTArray *node)
    {
        context->logger.logDebug(formatv("creating array of {0} elements", node->arguments.size()));

        IRBuilder<> Builder(context->llvmContext);
        Builder.SetInsertPoint(context->getCurrentBlock());

        Type *elementType = Type::getVoidTy(context->llvmContext);

        // Generate elements and determine type
        std::vector<Value *> elementValues;
        std::string currentTypeName = "";
        for (auto it = node->arguments.begin(); it != node->arguments.end(); it++)
        {
            CodeGenVisitor v(context);
            (**it).accept(&v);
            elementValues.push_back(v.result);
            if (elementType->isVoidTy())
            {
                elementType = v.result->getType();
            }

            // Check that all elements in the array are of the same type
            std::string newTypeName = context->getTypeName(v.result->getType());
            if (currentTypeName.compare("") != 0 && newTypeName.compare(currentTypeName) != 0)
            {
                context->logger.logError("array elements cannot be of different type");
            }
            currentTypeName = context->getTypeName(v.result->getType());
        }

        // Alloc inner array
        AllocaInst *innerArrayAlloc = new AllocaInst(ArrayType::get(elementType, node->arguments.size()), 0, "arrayinneralloc", context->getCurrentBlock());

        // Initialize inner array with elements
        // TODO : there is probably a way to write the whole content in a single instruction !!!
        long index = 0;
        for (auto it = elementValues.begin(); it != elementValues.end(); it++)
        {
            std::vector<llvm::Value *> indices;
            indices.push_back(ConstantInt::get(context->llvmContext, APInt(32, 0, true)));
            indices.push_back(ConstantInt::get(context->llvmContext, APInt(32, index, true)));
            Value *elementVarValue = Builder.CreateInBoundsGEP(innerArrayAlloc, indices, "elementptr");
            Builder.CreateStore(*it, elementVarValue);
            index++;
        }

        // Create array instance

        Value *arrayAlloc = new AllocaInst(context->getArrayComplexType(context->getTypeName(elementType))->getType(), 0, "arrayinit", context->getCurrentBlock());

        // Set len member
        Value *lenMember = Builder.CreateStructGEP(arrayAlloc, 1, "arrayleninit");
        Builder.CreateStore(ConstantInt::get(Type::getInt64Ty(context->llvmContext), node->arguments.size(), true), lenMember);

        // Set elements member with inner array
        Value *elementsMemberPointer = Builder.CreateStructGEP(arrayAlloc, 0, "arrayeleminit");
        Builder.CreateStore(innerArrayAlloc, elementsMemberPointer);

        // Return new instance
        this->result = Builder.CreateLoad(arrayAlloc->getType()->getPointerElementType(), arrayAlloc, "load");
    }

    void CodeGenVisitor::visit(ASTIdentifier *node)
    {
        context->logger.logDebug(formatv("creating identifier reference {0}", node->name));
        if (node->member != NULL)
        {
            context->logger.logDebug(formatv("identifier reference {0} is a nested identifier", node->name));
        }

        CodeGenVariable *var = context->getLocal(node->name);
        if (var == NULL)
        {
            context->logger.logError(formatv("undeclared identifier {0}", node->name));
        }

        IRBuilder<> Builder(context->llvmContext);
        Builder.SetInsertPoint(context->getCurrentBlock());

        // Retrieve variable complex type
        // Special case for array : if it is an array, use the array type
        CodeGenComplexType *complexType = var->isArray() ? context->getArrayComplexType(var->getTypeName()) : context->getComplexType(var->getTypeName());

        Value *varValue = getComplexTypeMemberValue(complexType, var->getValue(), node, context);
        this->result = Builder.CreateLoad(varValue->getType()->getPointerElementType(), varValue, "load");
    }

    void CodeGenVisitor::visit(ASTBlock *node)
    {

        ASTStatementList::const_iterator it;
        Value *last = NULL;

        for (it = node->statements.begin(); it != node->statements.end(); it++)
        {
            context->logger.logDebug(formatv("generating code for {0}", typeid(**it).name()));
            CodeGenVisitor v(context);
            (**it).accept(&v);
            last = v.result;
        }
        context->logger.logDebug("block created");
        this->result = last;
    }

    void CodeGenVisitor::visit(ASTAssignment *node)
    {

        context->logger.logDebug(formatv("creating assignment for {0}", node->lhs.name));

        CodeGenVariable *var = context->getLocal(node->lhs.name);
        if (var == NULL)
        {
            context->logger.logError(formatv("undeclared variable {0}", node->lhs.name));
        }
        CodeGenVisitor v(context);
        node->rhs.accept(&v);

        // Array case
        CodeGenComplexType *complexType = var->isArray() ? context->getArrayComplexType(var->getTypeName()) : context->getComplexType(var->getTypeName());

        Value *varValue = getComplexTypeMemberValue(complexType, var->getValue(), &node->lhs, context);

        this->result = new StoreInst(v.result, varValue, false, context->getCurrentBlock());
    }

    void CodeGenVisitor::visit(ASTExpressionStatement *node)
    {

        context->logger.logDebug(formatv("generating code for {0}", typeid(node->expression).name()));
        CodeGenVisitor v(context);
        node->expression.accept(&v);
        this->result = v.result;
    }

    void CodeGenVisitor::visit(ASTVariableDeclaration *node)
    {

        context->logger.logDebug(formatv("creating variable declaration {0} {1}", node->type.name, node->id.name));

        if (context->getLocal(node->id.name) != NULL)
        {
            context->logger.logError(formatv("variable {0} already declared", node->id.name));
        }

        // Type selection : based on the value of the declaration
        // Except if it is an array
        Type *type = typeOf(node->type, context);
        if (node->isArray)
        {
            type = context->getArrayComplexType(node->type.name)->getType();
        }

        CodeGenVariable *var = new CodeGenVariable(node->id.name, node->type.name, node->isArray, type);
        context->declareLocal(var);

        if (node->assignmentExpr != NULL)
        {
            ASTAssignment assn(node->id, *(node->assignmentExpr));
            CodeGenVisitor v(context);
            assn.accept(&v);
        }
        this->result = var->getValue();
    }

    void CodeGenVisitor::visit(ASTFunctionDeclaration *node)
    {

        context->logger.logDebug(formatv("creating function declaration for {0}", node->id.name));

        if (context->module->getFunction(node->id.name.c_str()) != NULL)
        {
            context->logger.logError(formatv("function {0} already declared", node->id.name));
        }

        // Build parameters
        vector<Type *> argTypes;
        ASTVariableList::const_iterator it;
        for (it = node->arguments.begin(); it != node->arguments.end(); it++)
        {
            argTypes.push_back(typeOf((**it).type, context));
        }

        // Create function

        Type *returnType = node->type.array ? context->getArrayComplexType(node->type.name)->getType() : typeOf(node->type, context);
        FunctionType *ftype = FunctionType::get(returnType, makeArrayRef(argTypes), false);
        Function *function = Function::Create(ftype, GlobalValue::InternalLinkage, node->id.name.c_str(), context->module);

        BasicBlock *bblock = BasicBlock::Create(context->llvmContext, "entry", function, 0);

        context->pushBlock(bblock);

        Function::arg_iterator argsValues = function->arg_begin();
        Value *argumentValue;

        for (it = node->arguments.begin(); it != node->arguments.end(); it++)
        {
            CodeGenVisitor v(context);
            (**it).accept(&v);

            argumentValue = &*argsValues++;
            argumentValue->setName((*it)->id.name.c_str());
            StoreInst *inst = new StoreInst(argumentValue, context->getLocal((*it)->id.name)->getValue(), false, context->getCurrentBlock());
        }

        CodeGenVisitor v(context);
        node->block.accept(&v);

        // Add return at the end.
        // If no return : add a default one
        if (context->getReturnValue() != NULL)
        {
            ReturnInst::Create(context->llvmContext, context->getReturnValue(), context->getCurrentBlock());
        }
        else
        {
            if (function->getReturnType()->isVoidTy())
            {
                // Add return to void function
                context->logger.logDebug(formatv("adding void return in {0}.{1}", context->getCurrentBlock()->getParent()->getName(), context->getCurrentBlock()->getName()));
                ReturnInst::Create(context->llvmContext, context->getCurrentBlock());
            }
            else
            {
                context->logger.logDebug(formatv("missing return in {0}.{1}, adding one with block value", context->getCurrentBlock()->getParent()->getName(), context->getCurrentBlock()->getName()));
                ReturnInst::Create(context->llvmContext, v.result, context->getCurrentBlock());
            }
        }

        context->popBlock();

        this->result = function;
    }

    void CodeGenVisitor::visit(ASTFunctionCall *node)
    {

        Function *function = context->module->getFunction(node->id.name.c_str());
        if (function == NULL)
        {
            context->logger.logError(formatv("undeclared function {0}", node->id.name));
        }
        std::vector<Value *> args;
        ASTExpressionList::const_iterator it;
        for (it = node->arguments.begin(); it != node->arguments.end(); it++)
        {
            CodeGenVisitor v(context);
            (**it).accept(&v);
            args.push_back(v.result);
        }

        CallInst *call = CallInst::Create(function, makeArrayRef(args), function->getReturnType()->isVoidTy() ? "" : "call", context->getCurrentBlock());
        context->logger.logDebug(formatv("creating method call {0}", node->id.name));
        this->result = call;
    }

    void CodeGenVisitor::visit(ASTExternDeclaration *node)
    {

        context->logger.logDebug(formatv("creating extern declaration for {0}", node->id.name));
        vector<Type *> argTypes;
        ASTVariableList::const_iterator it;
        for (it = node->arguments.begin(); it != node->arguments.end(); it++)
        {
            argTypes.push_back(typeOf((**it).type, context));
        }
        Type *returnType = node->type.array ? context->getArrayComplexType(node->type.name)->getType() : typeOf(node->type, context);
        FunctionType *ftype = FunctionType::get(returnType, makeArrayRef(argTypes), false);
        Function *function = Function::Create(ftype, GlobalValue::ExternalLinkage, node->id.name.c_str(), context->module);
        this->result = function;
    }

    void CodeGenVisitor::visit(ASTReturnStatement *node)
    {

        context->logger.logDebug(formatv("generating return code {0}", typeid(node->expression).name()));

        if (context->getCurrentBlock()->getTerminator() != NULL)
        {
            context->logger.logError("cannot add more than one terminator on a block");
        }

        CodeGenVisitor v(context);
        node->expression.accept(&v);
        Value *returnValue = v.result;

        // Store return value
        context->setReturnValue(returnValue);

        this->result = returnValue;
    }

    void CodeGenVisitor::visit(ASTBinaryOperator *node)
    {

        context->logger.logDebug(formatv("creating binary operation {0}", node->op));

        CodeGenVisitor vl(context);
        node->lhs.accept(&vl);
        CodeGenVisitor vr(context);
        node->rhs.accept(&vr);

        IRBuilder<> Builder(context->llvmContext);

        Builder.SetInsertPoint(context->getCurrentBlock());

        bool isDouble = vl.result->getType()->isDoubleTy();
        Instruction::BinaryOps instr;
        switch (node->op)
        {
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

        this->result = Builder.CreateBinOp(instr, vl.result, vr.result, "binop");
    }

    void CodeGenVisitor::visit(ASTComparison *node)
    {

        context->logger.logDebug(formatv("creating comparison {0}", node->op));

        IRBuilder<> Builder(context->llvmContext);

        CodeGenVisitor vl(context);
        node->lhs.accept(&vl);
        CodeGenVisitor vr(context);
        node->rhs.accept(&vr);

        Builder.SetInsertPoint(context->getCurrentBlock());

        bool isDouble = vl.result->getType()->isDoubleTy();
        Instruction::BinaryOps instr;
        switch (node->op)
        {
        case EQ:
            this->result = vl.result->getType()->isDoubleTy() ? Builder.CreateFCmpOEQ(vl.result, vr.result, "cmp") : Builder.CreateICmpEQ(vl.result, vr.result, "cmp");
            break;
        case NE:
            this->result = vl.result->getType()->isDoubleTy() ? Builder.CreateFCmpONE(vl.result, vr.result, "cmp") : Builder.CreateICmpNE(vl.result, vr.result, "cmp");
            break;
        case LT:
            this->result = vl.result->getType()->isDoubleTy() ? Builder.CreateFCmpOLT(vl.result, vr.result, "cmp") : Builder.CreateICmpSLT(vl.result, vr.result, "cmp");
            break;
        case LE:
            this->result = vl.result->getType()->isDoubleTy() ? Builder.CreateFCmpOLE(vl.result, vr.result, "cmp") : Builder.CreateICmpSLE(vl.result, vr.result, "cmp");
            break;
        case GT:
            this->result = vl.result->getType()->isDoubleTy() ? Builder.CreateFCmpOGT(vl.result, vr.result, "cmp") : Builder.CreateICmpSGT(vl.result, vr.result, "cmp");
            break;
        case GE:
            this->result = vl.result->getType()->isDoubleTy() ? Builder.CreateFCmpOGE(vl.result, vr.result, "cmp") : Builder.CreateICmpSGE(vl.result, vr.result, "cmp");
            break;
        }
    }

    void CodeGenVisitor::visit(ASTIfElseStatement *node)
    {

        context->logger.logDebug("creating if else statement");

        // Used to know if else block should be generated
        bool generateElseBlock = (node->falseBlock != NULL && node->falseBlock->statements.size() > 0);

        IRBuilder<> Builder(context->llvmContext);

        // Generate condition code
        CodeGenVisitor vc(context);
        node->condition.accept(&vc);

        // Get the function of the current block fon instertion
        Function *currentFunction = context->getCurrentBlock()->getParent();

        // Create blocks (and insert if block)
        BasicBlock *ifBlock = BasicBlock::Create(context->llvmContext, "if", currentFunction);
        BasicBlock *elseBlock = BasicBlock::Create(context->llvmContext, "else");
        BasicBlock *mergeBlock = BasicBlock::Create(context->llvmContext, "ifcont");

        // Create condition
        Builder.SetInsertPoint(context->getCurrentBlock());
        // If/else or simple if
        Value *condition = Builder.CreateCondBr(vc.result, ifBlock, generateElseBlock ? elseBlock : mergeBlock);

        // Generate if block
        context->pushBlock(ifBlock, true);

        CodeGenVisitor vt(context);
        node->trueBlock.accept(&vt);

        // Add branch to merge block
        Builder.SetInsertPoint(context->getCurrentBlock());
        if (context->getReturnValue() != NULL)
        {
            Builder.CreateRet(context->getReturnValue());
        }
        else
        {
            Builder.CreateBr(mergeBlock);
        }

        // Update if block pointer after generation (to support recursivity)
        ifBlock = Builder.GetInsertBlock();

        context->popBlock();

        // Generate else block (only if provided)
        CodeGenVisitor vf(context);
        if (generateElseBlock)
        {
            currentFunction->getBasicBlockList().push_back(elseBlock);
            Builder.SetInsertPoint(elseBlock);

            context->pushBlock(elseBlock, true);
            // If no else block: no generation
            node->falseBlock->accept(&vf);

            // Add branch to merge block
            Builder.SetInsertPoint(context->getCurrentBlock());
            if (context->getReturnValue() != NULL)
            {
                Builder.CreateRet(context->getReturnValue());
            }
            else
            {
                Builder.CreateBr(mergeBlock);
            }

            // Update else block pointer after generation (to support recursivity)
            elseBlock = Builder.GetInsertBlock();

            context->popBlock();
        }

        // Generate merge block
        currentFunction->getBasicBlockList().push_back(mergeBlock);
        Builder.SetInsertPoint(mergeBlock);

        context->pushBlock(mergeBlock, true);
        // Add PHI node (only if function should return something)
        if (!currentFunction->getReturnType()->isVoidTy())
        {
            PHINode *PN = Builder.CreatePHI(currentFunction->getReturnType(), 2, "iftmp");
            if (node->trueBlock.statements.size() > 0 && vt.result != NULL && !vt.result->getType()->isVoidTy())
            {
                PN->addIncoming(vt.result, ifBlock);
            }

            if (generateElseBlock && vf.result != NULL && !vf.result->getType()->isVoidTy())
                PN->addIncoming(vf.result, elseBlock);
            this->result = PN;
        }

        // Mark current block as merge block
        // In order to remember to double pop blocks at the end of a function
        context->setMergeBlock(true);
    }

    void CodeGenVisitor::visit(ASTWhileStatement *node)
    {

        context->logger.logDebug("creating while statement");

        // If no statement in block : nothing to do
        if (node->block.statements.size() == 0)
        {
            return;
        }

        IRBuilder<> Builder(context->llvmContext);

        // Get the function of the current block fon instertion
        Function *currentFunction = context->getCurrentBlock()->getParent();

        // Create blocks (and insert if block)
        BasicBlock *whileTestBlock = BasicBlock::Create(context->llvmContext, "whiletest", currentFunction);
        BasicBlock *whileBlock = BasicBlock::Create(context->llvmContext, "while");
        BasicBlock *mergeBlock = BasicBlock::Create(context->llvmContext, "whilecont");

        // Branch to test block
        Builder.SetInsertPoint(context->getCurrentBlock());
        Builder.CreateBr(whileTestBlock);

        // Generate test block ------------------------
        context->pushBlock(whileTestBlock, true);

        // Generate condition code
        CodeGenVisitor vc(context);
        node->condition.accept(&vc);

        // Generate condition branch
        Builder.SetInsertPoint(context->getCurrentBlock());
        Builder.CreateCondBr(vc.result, whileBlock, mergeBlock);

        // Update if block pointer after generation (to support recursivity)
        whileTestBlock = Builder.GetInsertBlock();

        context->popBlock();

        // Generate while block --------------------------
        CodeGenVisitor vb(context);
        currentFunction->getBasicBlockList().push_back(whileBlock);
        context->pushBlock(whileBlock, true);
        node->block.accept(&vb);

        // Create branch to test block, or return
        Builder.SetInsertPoint(context->getCurrentBlock());
        if (context->getReturnValue() != NULL)
        {
            Builder.CreateRet(context->getReturnValue());
        }
        else
        {
            Builder.CreateBr(whileTestBlock);
        }

        // Update if block pointer after generation (to support recursivity)
        whileBlock = Builder.GetInsertBlock();

        context->popBlock();

        // Generate merge block
        currentFunction->getBasicBlockList().push_back(mergeBlock);
        Builder.SetInsertPoint(mergeBlock);

        context->pushBlock(mergeBlock, true);

        // Mark current block as merge block
        // In order to remember to double pop blocks at the end of a function
        context->setMergeBlock(true);
    }

    void CodeGenVisitor::visit(ASTStructDeclaration *node)
    {
        context->logger.logDebug(formatv("creating struct declaration {0}", node->id.name));

        CodeGenComplexType *structType = new CodeGenComplexType(node->id.name, context);
        ASTVariableList::const_iterator it;
        for (it = node->arguments.begin(); it != node->arguments.end(); it++)
        {
            structType->addMember((**it).id.name, (**it).type.name, typeOf((**it).type, context), (**it).isArray);
        }
        context->declareComplexType(structType);
    }

} // namespace stark