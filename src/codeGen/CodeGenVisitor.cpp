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

    /* Returns an LLVM type based on the identifier */
    static Type *typeOf(const ASTIdentifier &type, CodeGenContext *context)
    {
        // Primary types
        if (type.name.compare("int") == 0)
        {
            return Type::getInt64Ty(context->llvmContext);
        }
        else if (type.name.compare("bool") == 0)
        {
            return Type::getInt1Ty(context->llvmContext);
        }
        else if (type.name.compare("double") == 0)
        {
            return Type::getDoubleTy(context->llvmContext);
        }

        // Complex types
        if (context->complexTypes.find(type.name) != context->complexTypes.end())
        {
            return context->complexTypes[type.name]->getType();
        }

        // Fallback to void
        return Type::getVoidTy(context->llvmContext);
    }

    /* Code generation */

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
        this->result = ConstantStruct::get(context->complexTypes["string"]->getType(), values);
    }

    void CodeGenVisitor::visit(ASTIdentifier *node)
    {
        context->logger.logDebug(formatv("creating identifier reference {0}", node->name));
        if (context->locals().find(node->name) == context->locals().end())
        {
            context->logger.logError(formatv("undeclared identifier {0}", node->name));
        }

        // Note : variables are stored as pointers into the symbol table
        // So, when we load the value of a variable, whe must use ->getType()->getPointerElementType()
        // From the variable type to get the real value (and not the pointer on that value)
        this->result = new LoadInst(context->locals()[node->name]->value->getType()->getPointerElementType(), context->locals()[node->name]->value, "load", false, context->currentBlock());
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
        if (context->locals().find(node->lhs.name) == context->locals().end())
        {
            context->logger.logError(formatv("undeclared variable {0}", node->lhs.name));
        }
        CodeGenVisitor v(context);
        node->rhs.accept(&v);

        this->result = new StoreInst(v.result, context->locals()[node->lhs.name]->value, false, context->currentBlock());
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

        if (context->locals().find(node->id.name) != context->locals().end())
        {
            context->logger.logError(formatv("variable {0} already declared", node->id.name));
        }

        AllocaInst *alloc = new AllocaInst(typeOf(node->type, context), 0, node->id.name.c_str(), context->currentBlock());
        context->locals()[node->id.name] = new CodeGenVariable(node->id.name, node->type.name, alloc);

        if (node->assignmentExpr != NULL)
        {
            ASTAssignment assn(node->id, *(node->assignmentExpr));
            CodeGenVisitor v(context);
            assn.accept(&v);
        }
        this->result = alloc;
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
        FunctionType *ftype = FunctionType::get(typeOf(node->type, context), makeArrayRef(argTypes), false);
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
            StoreInst *inst = new StoreInst(argumentValue, context->locals()[(*it)->id.name]->value, false, context->currentBlock());
        }

        CodeGenVisitor v(context);
        node->block.accept(&v);

        // Add return at the end.
        // If no return : add a default one
        if (context->returnValue() != NULL)
        {
            ReturnInst::Create(context->llvmContext, context->returnValue(), context->currentBlock());
        }
        else
        {
            if (function->getReturnType()->isVoidTy())
            {
                // Add return to void function
                context->logger.logDebug(formatv("adding void return in {0}.{1}", context->currentBlock()->getParent()->getName(), context->currentBlock()->getName()));
                ReturnInst::Create(context->llvmContext, context->currentBlock());
            }
            else
            {
                context->logger.logDebug(formatv("missing return in {0}.{1}, adding one with block value", context->currentBlock()->getParent()->getName(), context->currentBlock()->getName()));
                ReturnInst::Create(context->llvmContext, v.result, context->currentBlock());
            }
        }

        context->popBlock();

        this->result = function;
    }

    void CodeGenVisitor::visit(ASTMethodCall *node)
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

        CallInst *call = CallInst::Create(function, makeArrayRef(args), function->getReturnType()->isVoidTy() ? "" : "call", context->currentBlock());
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
        FunctionType *ftype = FunctionType::get(typeOf(node->type, context), makeArrayRef(argTypes), false);
        Function *function = Function::Create(ftype, GlobalValue::ExternalLinkage, node->id.name.c_str(), context->module);
        this->result = function;
    }

    void CodeGenVisitor::visit(ASTReturnStatement *node)
    {

        context->logger.logDebug(formatv("generating return code {0}", typeid(node->expression).name()));

        if (context->currentBlock()->getTerminator() != NULL)
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

        Builder.SetInsertPoint(context->currentBlock());

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

        Builder.SetInsertPoint(context->currentBlock());

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
        Function *currentFunction = context->currentBlock()->getParent();

        // Create blocks (and insert if block)
        BasicBlock *ifBlock = BasicBlock::Create(context->llvmContext, "if", currentFunction);
        BasicBlock *elseBlock = BasicBlock::Create(context->llvmContext, "else");
        BasicBlock *mergeBlock = BasicBlock::Create(context->llvmContext, "ifcont");

        // Create condition
        Builder.SetInsertPoint(context->currentBlock());
        // If/else or simple if
        Value *condition = Builder.CreateCondBr(vc.result, ifBlock, generateElseBlock ? elseBlock : mergeBlock);

        // Generate if block
        context->pushBlock(ifBlock, true);

        CodeGenVisitor vt(context);
        node->trueBlock.accept(&vt);

        // Add branch to merge block
        Builder.SetInsertPoint(context->currentBlock());
        if (context->returnValue() != NULL)
        {
            Builder.CreateRet(context->returnValue());
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
            Builder.SetInsertPoint(context->currentBlock());
            if (context->returnValue() != NULL)
            {
                Builder.CreateRet(context->returnValue());
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
        Function *currentFunction = context->currentBlock()->getParent();

        // Create blocks (and insert if block)
        BasicBlock *whileTestBlock = BasicBlock::Create(context->llvmContext, "whiletest", currentFunction);
        BasicBlock *whileBlock = BasicBlock::Create(context->llvmContext, "while");
        BasicBlock *mergeBlock = BasicBlock::Create(context->llvmContext, "whilecont");

        // Branch to test block
        Builder.SetInsertPoint(context->currentBlock());
        Builder.CreateBr(whileTestBlock);

        // Generate test block ------------------------
        context->pushBlock(whileTestBlock, true);

        // Generate condition code
        CodeGenVisitor vc(context);
        node->condition.accept(&vc);

        // Generate condition branch
        Builder.SetInsertPoint(context->currentBlock());
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
        Builder.SetInsertPoint(context->currentBlock());
        if (context->returnValue() != NULL)
        {
            Builder.CreateRet(context->returnValue());
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

    void CodeGenVisitor::visit(ASTMemberAccess *node)
    {
        context->logger.logDebug(formatv("creating member access for {0}.{1}", node->variable.name, node->member.name));

        if (context->locals().find(node->variable.name) == context->locals().end())
        {
            context->logger.logError(formatv("undeclared identifier {0}", node->variable.name));
        }


        IRBuilder<> Builder(context->llvmContext);
        Builder.SetInsertPoint(context->currentBlock());

        // Retrieve variable
        CodeGenVariable *variable = context->locals()[node->variable.name];

        // Retrieve complex type
        CodeGenComplexType *complexType = context->complexTypes[variable->typeName];

        // Retrieve member
        CodeGenComplexTypeMember *member = complexType->getMember(node->member.name);
        if (member == NULL) {
            context->logger.logError(formatv("no member named {0} for variable {1} ({2})", node->member.name, node->variable.name, complexType->name));
        }

        // Access 2 arg
        std::vector<llvm::Value *> indices;
        indices.push_back(ConstantInt::get(context->llvmContext, APInt(32, 0, true)));
        indices.push_back(ConstantInt::get(context->llvmContext, APInt(32, member->position, true)));
        Value *memberValue = Builder.CreateGEP(context->locals()[node->variable.name]->value, indices, "memberptr");
        this->result = Builder.CreateLoad(memberValue->getType()->getPointerElementType(), memberValue, "loadmember");
    }

} // namespace stark