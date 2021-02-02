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
                context->logger.logError(identifier->location, formatv("{0} is not an array type", complexType->getName()));
            }

            context->logger.logDebug(identifier->location, "resolving array index");

            // Evaluate index expression
            CodeGenVisitor vi(context);
            identifier->index->accept(&vi);
            Value *indexExprAsInt32 = Builder.CreateIntCast(vi.result, Type::getInt32Ty(context->llvmContext), false);

            // Get elements member
            CodeGenComplexTypeMember *elementsMember = complexType->getMember("elements");

            // Get elements pointer (and load in between 2 GEPs !)
            Value *elementsPointer = Builder.CreateStructGEP(varValue, elementsMember->position, "elementptrs");
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
            context->logger.logDebug(identifier->location, formatv("resolving value for {0} in complex type {1}", identifier->member->name, complexType->getName()));

            CodeGenComplexTypeMember *complexTypeMember = complexType->getMember(identifier->member->name);
            if (complexTypeMember == NULL)
            {
                context->logger.logError(identifier->location, formatv("no member named {0} for type {1}", identifier->member->name, complexType->getName()));
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

        context->logger.logDebug(node->location, formatv("creating integer {0}", node->value));
        this->result = context->getPrimaryType("int")->create(node->value, node->location);
    }

    void CodeGenVisitor::visit(ASTBoolean *node)
    {
        context->logger.logDebug(node->location, formatv("creating boolean {0}", node->value));
        this->result = context->getPrimaryType("bool")->create(node->value, node->location);
    }

    void CodeGenVisitor::visit(ASTDouble *node)
    {

        context->logger.logDebug(node->location, formatv("creating double {0}", node->value));
        this->result = context->getPrimaryType("double")->create(node->value, node->location);
    }

    void CodeGenVisitor::visit(ASTString *node)
    {
        context->logger.logDebug(node->location, formatv("creating string {0}", node->value));
        this->result = context->getComplexType("string")->create(node->value, node->location);
    }

    void CodeGenVisitor::visit(ASTArray *node)
    {
        context->logger.logDebug(node->location, formatv("creating array of {0} elements", node->arguments.size()));

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
                context->logger.logError(node->location, "array elements cannot be of different type");
            }
            currentTypeName = context->getTypeName(v.result->getType());
        }

        // Return new instance
        this->result = context->getArrayComplexType(context->getTypeName(elementType))->create(elementValues, node->location);
    }

    void CodeGenVisitor::visit(ASTIdentifier *node)
    {
        context->logger.logDebug(node->location, formatv("creating identifier reference {0}", node->name));
        if (node->member != NULL)
        {
            context->logger.logDebug(node->location, formatv("identifier reference {0} is a nested identifier", node->name));
        }

        CodeGenVariable *var = context->getLocal(node->name);
        if (var == NULL)
        {
            context->logger.logError(node->location, formatv("undeclared identifier {0}", node->name));
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

        context->logger.logDebug(node->location, "generating block");

        for (it = node->statements.begin(); it != node->statements.end(); it++)
        {
            CodeGenVisitor v(context);
            (**it).accept(&v);
            last = v.result;
        }
        context->logger.logDebug(node->location, "block created");
        this->result = last;
    }

    void CodeGenVisitor::visit(ASTAssignment *node)
    {

        context->logger.logDebug(node->location, formatv("creating assignment for {0}", node->lhs.name));

        CodeGenVariable *var = context->getLocal(node->lhs.name);
        if (var == NULL)
        {
            context->logger.logError(node->location, formatv("undeclared variable {0}", node->lhs.name));
        }
        CodeGenVisitor v(context);
        node->rhs.accept(&v);

        // Array case
        CodeGenComplexType *complexType = var->isArray() ? context->getArrayComplexType(var->getTypeName()) : context->getComplexType(var->getTypeName());

        Value *varValue = getComplexTypeMemberValue(complexType, var->getValue(), &node->lhs, context);

        // Check types
        std::string valueTypeName = context->getTypeName(v.result->getType());
        std::string varTypeName = context->getTypeName(varValue->getType()->getPointerElementType());
        if (varTypeName.compare(valueTypeName) != 0)
        {
            context->logger.logError(node->location, formatv("cannot assign value of type {0} to variable {1} of type {2}", valueTypeName, var->getName(), varTypeName));
        }

        this->result = new StoreInst(v.result, varValue, false, context->getCurrentBlock());
    }

    void CodeGenVisitor::visit(ASTExpressionStatement *node)
    {

        context->logger.logDebug(node->location, formatv("generating code for {0}", typeid(node->expression).name()));
        CodeGenVisitor v(context);
        node->expression.accept(&v);
        this->result = v.result;
    }

    void CodeGenVisitor::visit(ASTVariableDeclaration *node)
    {

        context->logger.logDebug(node->location, formatv("creating variable declaration {0} {1}", node->type.name, node->id.name));

        if (context->getLocal(node->id.name) != NULL)
        {
            context->logger.logError(node->location, formatv("variable {0} already declared", node->id.name));
        }

        // Type selection : based on the value of the declaration
        // Except if it is an array
        Type *type = context->getType(node->type.name);
        if (node->isArray)
        {
            type = context->getArrayComplexType(node->type.name)->getType();
        }

        if (type == NULL)
        {
            context->logger.logError(node->location, formatv("unknown type {0}", node->type.name));
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

    void CodeGenVisitor::visit(ASTFunctionDefinition *node)
    {

        context->logger.logDebug(node->location, formatv("creating function definition for {0}", node->id.name));

        // Mangle name
        std::string functionName = context->getMangler()->mangleFunctionName(node->id.name, context->getModuleName());

        if (context->getLLvmModule()->getFunction(functionName.c_str()) != NULL)
        {
            context->logger.logError(node->location, formatv("function {0} already declared", node->id.name));
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
        // TODO : being able to change function visibility by changing ExternalLinkage
        // See https://llvm.org/docs/LangRef.html
        Function *function = Function::Create(ftype, GlobalValue::ExternalLinkage, functionName.c_str(), context->getLLvmModule());
        
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

        // When not running in interpreter mode : try init memory manager
        // (must be done after the begining of the main function)
        if (!context->isInterpreterMode())
        {
            context->initMemoryManager();
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
                context->logger.logDebug(node->location, formatv("adding void return in {0}.{1}", context->getCurrentBlock()->getParent()->getName(), context->getCurrentBlock()->getName()));
                ReturnInst::Create(context->llvmContext, context->getCurrentBlock());
            }
            else
            {
                context->logger.logDebug(node->location, formatv("missing return in {0}.{1}, adding one with block value", context->getCurrentBlock()->getParent()->getName(), context->getCurrentBlock()->getName()));
                ReturnInst::Create(context->llvmContext, v.result, context->getCurrentBlock());
            }
        }

        context->popBlock();

        this->result = function;
    }

    void CodeGenVisitor::visit(ASTFunctionCall *node)
    {
        // First try to find a runtime function
        Function *function = context->getLLvmModule()->getFunction(context->getMangler()->manglePublicRuntimeFunctionName(node->id.name).c_str());
        // Then look in stark functions
        if (function == NULL)
        {
            function = context->getLLvmModule()->getFunction(context->getMangler()->mangleFunctionName(node->id.name, context->getModuleName()).c_str());
        }
        // Finally : look for an unmangled function
        if (function == NULL)
        {
            function = context->getLLvmModule()->getFunction(node->id.name.c_str());
        }

        if (function == NULL)
        {
            context->logger.logError(node->location, formatv("undeclared function {0}", node->id.name));
        }

        // Check that function can be called
        context->checkFunctionCallAccess(node->id.name, node->location);

        std::vector<Value *> args;
        ASTExpressionList::const_iterator it;
        int i = 0;
        for (it = node->arguments.begin(); it != node->arguments.end(); it++)
        {
            CodeGenVisitor v(context);
            (**it).accept(&v);

            // Check arg type
            std::string argTypeName = context->getTypeName(function->getArg(i)->getType());
            std::string valueTypeName = context->getTypeName(v.result->getType());
            if (argTypeName.compare(valueTypeName) != 0)
            {
                context->logger.logError(node->location, formatv("function {0} is expecting a {1} type for argument number {2}, instead of {3} type", node->id.name, argTypeName, i, valueTypeName));
            }

            args.push_back(v.result);
            i++;
        }

        CallInst *call = CallInst::Create(function, makeArrayRef(args), function->getReturnType()->isVoidTy() ? "" : "call", context->getCurrentBlock());
        context->logger.logDebug(node->location, formatv("creating method call {0}", node->id.name));
        this->result = call;
    }

    void CodeGenVisitor::visit(ASTFunctionDeclaration *node)
    {
        context->logger.logDebug(node->location, formatv("creating function declaration for {0}", node->id.name));

        std::string moduleName = "main";
        std::string functionName = node->id.name;

        int memberCount = node->id.countNestedMembers();
        // If identifier has a member : then it is module.function
        if (memberCount == 1)
        {
            moduleName = node->id.name;
            functionName = node->id.member->name;
        }
        // If more than one member : identifier is invalid
        else if (memberCount > 1)
        {
            context->logger.logError(node->location, formatv("invalid identifier {0} for function declaration, expecting <function name> or <module name>.<function name>", node->id.getFullName()));
        }

        // Mangle
        std::string mangledName = context->getMangler()->mangleFunctionName(functionName, moduleName);
        ASTIdentifier newId(mangledName, NULL, NULL);

        // Generate new extern
        ASTExternDeclaration externDeclaration(node->type, newId, node->arguments);
        CodeGenVisitor v(context);
        externDeclaration.accept(&v);
    }

    void CodeGenVisitor::visit(ASTExternDeclaration *node)
    {

        context->logger.logDebug(node->location, formatv("creating extern declaration for {0}", node->id.name));

        std::string functionName = node->id.name;

        vector<Type *> argTypes;
        ASTVariableList::const_iterator it;
        for (it = node->arguments.begin(); it != node->arguments.end(); it++)
        {
            argTypes.push_back(typeOf((**it).type, context));
        }

        Type *returnType = node->type.array ? context->getArrayComplexType(node->type.name)->getType() : typeOf(node->type, context);
        FunctionType *ftype = FunctionType::get(returnType, makeArrayRef(argTypes), false);
        Function *function = Function::Create(ftype, GlobalValue::ExternalLinkage, functionName.c_str(), context->getLLvmModule());
        this->result = function;

        // If in interpreter mode : try to init the memory manager
        // as soon as the required runtime function is declared
        if (context->isInterpreterMode())
        {
            context->initMemoryManager();
        }
    }

    void CodeGenVisitor::visit(ASTReturnStatement *node)
    {

        context->logger.logDebug(node->location, formatv("generating return code {0}", typeid(node->expression).name()));

        if (context->getCurrentBlock()->getTerminator() != NULL)
        {
            context->logger.logError(node->location, "cannot add more than one terminator on a block");
        }

        CodeGenVisitor v(context);
        node->expression.accept(&v);
        Value *returnValue = v.result;

        // Store return value
        context->setReturnValue(returnValue);

        this->result = returnValue;
    }

    void CodeGenVisitor::visit(ASTBinaryOperation *node)
    {

        context->logger.logDebug(node->location, formatv("creating binary operation {0}", node->op));

        // Evaluate operands
        CodeGenVisitor vl(context);
        node->lhs.accept(&vl);
        CodeGenVisitor vr(context);
        node->rhs.accept(&vr);

        std::string lhsTypeName = context->getTypeName(vl.result->getType());
        std::string rhsTypeName = context->getTypeName(vr.result->getType());

        // Operands must be of same type
        if (lhsTypeName.compare(rhsTypeName) != 0)
        {
            context->logger.logError(node->location, formatv("operands must be of same type for binary operations"));
        }

        // Binary operation are supported on primary types only
        if (!context->isPrimaryType(lhsTypeName))
        {
            context->logger.logError(node->location, formatv("binary operation is not supported on type {0}", lhsTypeName));
        }

        this->result = this->context->getPrimaryType(lhsTypeName)->createBinaryOperation(vl.result, node->op, vr.result, node->location);
    }

    void CodeGenVisitor::visit(ASTComparison *node)
    {

        context->logger.logDebug(node->location, formatv("creating comparison {0}", node->op));

        IRBuilder<> Builder(context->llvmContext);

        CodeGenVisitor vl(context);
        node->lhs.accept(&vl);
        CodeGenVisitor vr(context);
        node->rhs.accept(&vr);

        std::string lhsTypeName = context->getTypeName(vl.result->getType());
        std::string rhsTypeName = context->getTypeName(vr.result->getType());

        // Operands must be of same type
        if (lhsTypeName.compare(rhsTypeName) != 0)
        {
            context->logger.logError(node->location, formatv("cannot compare values of diffrent types"));
        }

        // Comparisons are supported on primary types only
        if (!context->isPrimaryType(lhsTypeName))
        {
            context->logger.logError(node->location, formatv("comparison is not supported on type {0}", lhsTypeName));
        }

        this->result = this->context->getPrimaryType(lhsTypeName)->createComparison(vl.result, node->op, vr.result, node->location);
    }

    void CodeGenVisitor::visit(ASTIfElseStatement *node)
    {

        context->logger.logDebug(node->location, "creating if else statement");

        // Used to know if else block should be generated
        bool generateElseBlock = (node->falseBlock != NULL && node->falseBlock->statements.size() > 0);

        if (node->trueBlock.statements.size() == 0 && !generateElseBlock)
        {
            return;
        }

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

        context->logger.logDebug(node->location, "creating while statement");

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
        context->logger.logDebug(node->location, formatv("creating struct declaration {0}", node->id.name));

        if(context->getComplexType(node->id.name) != NULL) {
            context->logger.logError(node->location, formatv("type {0} already declared", node->id.name));
        }


        CodeGenComplexType *structType = new CodeGenComplexType(node->id.name, context);
        ASTVariableList::const_iterator it;
        for (it = node->arguments.begin(); it != node->arguments.end(); it++)
        {
            structType->addMember((**it).id.name, (**it).type.name, typeOf((**it).type, context), (**it).isArray);
        }
        context->declareComplexType(structType);
    }

    void CodeGenVisitor::visit(ASTTypeConversion *node)
    {
        context->logger.logDebug(node->location, formatv("creating type convertion to type {0}", node->type.name));

        // Evaluate expression
        CodeGenVisitor v(context);
        node->expression.accept(&v);

        std::string exprTypeName = context->getTypeName(v.result->getType());

        // Type conversion is not suported on complex types
        if (context->isPrimaryType(exprTypeName))
        {
            this->result = context->getPrimaryType(exprTypeName)->convert(v.result, node->type.name, node->location);
        }
        else
        {
            this->result = context->getComplexType(exprTypeName)->convert(v.result, node->type.name, node->location);
        }
    }

} // namespace stark