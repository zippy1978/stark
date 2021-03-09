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

#include "CodeGenConstants.h"
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
    static Value *getComplexTypeMemberValue(CodeGenComplexType *complexType, Value *varValue, ASTIdentifier *identifier, CodeGenFileContext *context)
    {

        IRBuilder<> Builder(context->getLlvmContext());
        Builder.SetInsertPoint(context->getCurrentBlock());

        // Array case : must point to index element
        if (identifier->getIndex() != nullptr)
        {

            if (!complexType->isArray())
            {
                context->logger.logError(identifier->location, formatv("{0} is not an array type", complexType->getName()));
            }

            context->logger.logDebug(identifier->location, "resolving array index");

            // Evaluate index expression
            CodeGenVisitor vi(context);
            identifier->getIndex()->accept(&vi);
            Value *indexExprAsInt32 = Builder.CreateIntCast(vi.result, Type::getInt32Ty(context->getLlvmContext()), false);

            // Get elements member
            CodeGenComplexTypeMember *elementsMember = complexType->getMember("elements");

            // Get elements pointer (and load in between 2 GEPs !)
            varValue = Builder.CreateLoad(varValue);
            Value *elementsPointer = Builder.CreateStructGEP(varValue, elementsMember->position, "elementptrs");
            varValue = Builder.CreateLoad(elementsPointer);

            // Get position in elements pointer
            varValue = Builder.CreateInBoundsGEP(varValue, indexExprAsInt32);

            // Set current complex type as array element type
            complexType = elementsMember->array ? context->getArrayComplexType(elementsMember->typeName) : context->getComplexType(elementsMember->typeName);

            // Remove index to be treated as normal complex type on next call
            identifier->setIndex(nullptr);

            // Recurse
            return getComplexTypeMemberValue(complexType, varValue, identifier, context);
        }
        else if (identifier->getMember() != nullptr)
        {
            context->logger.logDebug(identifier->location, formatv("resolving value for {0} in complex type {1}", identifier->getMember()->getName(), complexType->getName()));

            CodeGenComplexTypeMember *complexTypeMember = complexType->getMember(identifier->getMember()->getName());
            if (complexTypeMember == nullptr)
            {
                context->logger.logError(identifier->location, formatv("no member named {0} for type {1}", identifier->getMember()->getName(), complexType->getName()));
            }

            // Load member value
            varValue = Builder.CreateLoad(varValue);
            varValue = Builder.CreateStructGEP(varValue, complexTypeMember->position, "memberptr");

            // Is member a complex type ?
            // Handle special type lookup for array
            complexType = complexTypeMember->array ? context->getArrayComplexType(complexTypeMember->typeName) : context->getComplexType(complexTypeMember->typeName);

            // Recurse
            return getComplexTypeMemberValue(complexType, varValue, identifier->getMember(), context);
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
    static Type *typeOf(ASTIdentifier &type, CodeGenFileContext *context)
    {
        return context->getType(type.getFullName());
    }

    // Code generation

    Function *CodeGenVisitor::createExternalDeclaration(std::string functionName, ASTVariableList arguments, ASTIdentifier *type)
    {
        vector<Type *> argTypes;

        for (auto it = arguments.begin(); it != arguments.end(); it++)
        {
            ASTVariableDeclaration *vd = *it;
            std::string typeName = vd->getType()->getFullName();
            Type *varType = context->getType(typeName);

            // Array case
            if (vd->getType()->isArray())
            {
                varType = context->getArrayComplexType(typeName)->getType()->getPointerTo();
            }

            // Complex types are pointers !
            if (!context->isPrimaryType(typeName) && !vd->getType()->isArray())
            {
                varType = varType->getPointerTo();
            }

            argTypes.push_back(varType);
        }

        Type *returnType;
        if (type == nullptr)
        {
            returnType = context->getPrimaryType("void")->getType();
        }
        else
        {
            returnType = type->isArray() ? context->getArrayComplexType(type->getFullName())->getType()->getPointerTo() : typeOf(*type, context);

            // Complex types are pointers !
            if (!context->isPrimaryType(type->getFullName()) && !type->isArray())
            {
                returnType = returnType->getPointerTo();
            }
        }

        FunctionType *ftype = FunctionType::get(returnType, makeArrayRef(argTypes), false);
        Function *function = Function::Create(ftype, GlobalValue::ExternalLinkage, functionName.c_str(), context->getLlvmModule());

        // If in interpreter mode : try to init the memory manager
        // as soon as the required runtime function is declared
        if (context->isInterpreterMode())
        {
            context->initMemoryManager();
        }

        return function;
    }

    void CodeGenVisitor::visit(ASTInteger *node)
    {

        context->logger.logDebug(node->location, formatv("creating integer {0}", node->getValue()));
        this->result = context->getPrimaryType("int")->create(node->getValue(), node->location);
    }

    void CodeGenVisitor::visit(ASTBoolean *node)
    {
        context->logger.logDebug(node->location, formatv("creating boolean {0}", node->getValue()));
        this->result = context->getPrimaryType("bool")->create(node->getValue(), node->location);
    }

    void CodeGenVisitor::visit(ASTDouble *node)
    {

        context->logger.logDebug(node->location, formatv("creating double {0}", node->getValue()));
        this->result = context->getPrimaryType("double")->create(node->getValue(), node->location);
    }

    void CodeGenVisitor::visit(ASTString *node)
    {
        context->logger.logDebug(node->location, formatv("creating string {0}", node->getValue()));
        this->result = context->getComplexType("string")->create(node->getValue(), node->location);
    }

    void CodeGenVisitor::visit(ASTNull *node)
    {
        context->logger.logDebug(node->location, "creating null");
        this->result = ConstantPointerNull::getNullValue(Type::getInt8PtrTy(context->getLlvmContext()));
    }

    void CodeGenVisitor::visit(ASTArray *node)
    {
        context->logger.logDebug(node->location, formatv("creating array of {0} elements", node->getArguments().size()));

        IRBuilder<> Builder(context->getLlvmContext());
        Builder.SetInsertPoint(context->getCurrentBlock());

        Type *elementType = Type::getVoidTy(context->getLlvmContext());

        // Generate elements and determine type
        std::vector<Value *> elementValues;
        ASTExpressionList arguments = node->getArguments();
        std::string currentTypeName = "";
        for (auto it = arguments.begin(); it != arguments.end(); it++)
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

        context->logger.logDebug(node->location, formatv("creating identifier reference {0}", node->getFullName()));

        CodeGenVariable *var = context->getLocal(node->getName());
        if (var == nullptr)
        {
            context->logger.logError(node->location, formatv("undeclared identifier {0}", node->getName()));
        }

        IRBuilder<> Builder(context->getLlvmContext());
        Builder.SetInsertPoint(context->getCurrentBlock());

        // Retrieve variable complex type
        // Special case for array : if it is an array, use the array type
        CodeGenComplexType *complexType = var->isArray() ? context->getArrayComplexType(var->getTypeName()) : context->getComplexType(var->getTypeName());

        Value *varValue = getComplexTypeMemberValue(complexType, var->getValue(), node, context);

        std::string typeName = context->getTypeName(varValue->getType());
        Type *type = varValue->getType()->getPointerElementType();

        this->result = Builder.CreateLoad(type, varValue, "load");
    }

    void CodeGenVisitor::visit(ASTBlock *node)
    {

        ASTStatementList::const_iterator it;
        Value *last = nullptr;

        context->logger.logDebug(node->location, "generating block");

        bool isOnRoot = context->getCurrentBlock() == nullptr;

        ASTStatementList statements = node->getStatements();

        // Look for module declaration on first statement of the root block
        // Also : modules are not supported in interpreter mode
        if (isOnRoot && statements.size() > 0 && !context->isInterpreterMode())
        {
            if (dynamic_cast<ASTModuleDeclaration *>(node->getStatements()[0]))
            {
                ASTModuleDeclaration *d = static_cast<ASTModuleDeclaration *>(node->getStatements()[0]);

                context->getChecker()->checkAllowedModuleDeclaration(d->getId());

                context->logger.logDebug(node->location, formatv("declaring module {0}", d->getId()->getFullName()));
                context->setModuleName(d->getId()->getFullName());

                // Remove from statements to process
                statements.erase(statements.begin());
            }
        }

        for (it = statements.begin(); it != statements.end(); it++)
        {
            ASTStatement *s = *it;
            CodeGenVisitor v(context);
            s->accept(&v);
            last = v.result;
        }
        context->logger.logDebug(node->location, "block created");
        this->result = last;
    }

    void CodeGenVisitor::visit(ASTAssignment *node)
    {

        context->logger.logDebug(node->location, formatv("creating assignment for {0}", node->getLhs()->getName()));

        // Check declaration
        context->getChecker()->checkAllowedVariableDeclaration(node->getLhs());

        // Get variable definition
        CodeGenVariable *var = context->getLocal(node->getLhs()->getName());

        // Generate value
        CodeGenVisitor v(context);
        node->getRhs()->accept(&v);

        // Array case
        CodeGenComplexType *complexType = var->isArray() ? context->getArrayComplexType(var->getTypeName()) : context->getComplexType(var->getTypeName());

        // Retrieve variable
        Value *varValue = getComplexTypeMemberValue(complexType, var->getValue(), node->getLhs(), context);

        Value *assignedValue = v.result;

        // If assigned value is null : create appropriate constant
        if (context->getChecker()->isNull(v.result))
        {
            assignedValue = ConstantPointerNull::getNullValue(varValue->getType()->getPointerElementType());
        }

        // Check types
        context->getChecker()->checkVariableAssignment(node->getLhs(), varValue, assignedValue);

        // Store value
        this->result = new StoreInst(assignedValue, varValue, false, context->getCurrentBlock());
    }

    void CodeGenVisitor::visit(ASTExpressionStatement *node)
    {

        auto &r = *node->getExpression();
        context->logger.logDebug(node->location, formatv("generating code for {0}", typeid(r).name()));
        CodeGenVisitor v(context);
        node->getExpression()->accept(&v);
        this->result = v.result;
    }

    void CodeGenVisitor::visit(ASTVariableDeclaration *node)
    {

        context->logger.logDebug(node->location, formatv("creating variable declaration {0}", node->getId()->getName()));

        // Check that variable name is available
        context->getChecker()->checkAvailableLocalVariable(node->getId());

        // var: type [= expr]
        if (node->getType() != nullptr)
        {
            // Type selection : based on the value of the declaration
            // Except if it is an array
            Type *type = context->getType(node->getType()->getFullName());
            if (node->isArray())
            {
                // Array variables are pointers !
                type = context->getArrayComplexType(node->getType()->getFullName())->getType()->getPointerTo();
            }

            if (type == nullptr)
            {
                context->logger.logError(node->location, formatv("unknown type {0}", node->getType()->getFullName()));
            }

            // All complex types are pointer variables (be careful not to process array type once again)
            if (!context->isPrimaryType(node->getType()->getFullName()) && !node->isArray())
            {
                type = type->getPointerTo();
            }

            CodeGenVariable *var = new CodeGenVariable(node->getId()->getName(), node->getType()->getFullName(), node->isArray(), type);
            context->declareLocal(var);

            if (node->getAssignmentExpr() != nullptr)
            {
                ASTAssignment assn(node->getId()->clone(), node->getAssignmentExpr()->clone());
                CodeGenVisitor v(context);
                assn.accept(&v);
            }

            this->result = var->getValue();
        }
        // No type: infer it from assignement (var := expr)
        else
        {
            CodeGenVisitor v(context);
            node->getAssignmentExpr()->accept(&v);
            Type *type = v.result->getType();
            std::string typeName = context->getTypeName(type);
            bool isArray = false;
            if (context->isArrayType(typeName))
            {
                type = context->getArrayComplexType(typeName)->getType();
                isArray = true;
            }

            CodeGenVariable *var = new CodeGenVariable(node->getId()->getName(), typeName, isArray, type);
            context->declareLocal(var);

            this->result = new StoreInst(v.result, var->getValue(), false, context->getCurrentBlock());
        }
    }

    void CodeGenVisitor::visit(ASTFunctionDefinition *node)
    {

        context->logger.logDebug(node->location, formatv("creating function definition for {0}", node->getId()->getName()));

        // Check declaration
        context->getChecker()->checkAllowedFunctionDeclaration(node->getId());

        // Mangle name
        std::string functionName = context->getMangler()->mangleFunctionName(node->getId()->getName(), context->getModuleName());

        ASTVariableList arguments = node->getArguments();

        // Build parameters
        vector<Type *> argTypes;
        ASTVariableList::const_iterator it;
        for (it = arguments.begin(); it != arguments.end(); it++)
        {
            ASTVariableDeclaration *v = *it;
            Type *type = context->getType(v->getType()->getFullName());
            if (v->isArray())
            {
                type = context->getArrayComplexType(v->getType()->getFullName())->getType()->getPointerTo();
            }

            if (type == nullptr)
            {
                context->logger.logError(v->location, formatv("unknown type {0}", v->getType()->getFullName()));
            }

            // Complex types are pointer variables !
            if (!context->isPrimaryType(v->getType()->getFullName()) && !v->isArray())
            {
                type = type->getPointerTo();
            }

            argTypes.push_back(type);
        }

        // Create function

        // If no return type : void is assumed
        Type *returnType;
        if (node->getType() == nullptr)
        {
            returnType = context->getPrimaryType("void")->getType();
        }
        else
        {
            returnType = node->getType()->isArray() ? context->getArrayComplexType(node->getType()->getFullName())->getType() : typeOf(*node->getType(), context);
        }

        FunctionType *ftype = FunctionType::get(returnType, makeArrayRef(argTypes), false);
        // TODO : being able to change function visibility by changing ExternalLinkage
        // See https://llvm.org/docs/LangRef.html
        Function *function = Function::Create(ftype, GlobalValue::ExternalLinkage, functionName.c_str(), context->getLlvmModule());

        BasicBlock *bblock = BasicBlock::Create(context->getLlvmContext(), "entry", function, 0);

        context->pushBlock(bblock);

        Function::arg_iterator argsValues = function->arg_begin();
        Value *argumentValue;

        for (it = arguments.begin(); it != arguments.end(); it++)
        {
            CodeGenVisitor v(context);
            (**it).accept(&v);

            argumentValue = &*argsValues++;
            argumentValue->setName((*it)->getId()->getName().c_str());
            StoreInst *inst = new StoreInst(argumentValue, context->getLocal((*it)->getId()->getName())->getValue(), false, context->getCurrentBlock());
        }

        // When not running in interpreter mode : try init memory manager
        // (must be done after the begining of the main function)
        if (!context->isInterpreterMode())
        {
            context->initMemoryManager();
        }

        CodeGenVisitor v(context);
        node->getBlock()->accept(&v);

        // Add return at the end.
        // If no return : add a default one
        if (context->getReturnValue() != nullptr)
        {
            ReturnInst::Create(context->getLlvmContext(), context->getReturnValue(), context->getCurrentBlock());
        }
        else
        {
            if (function->getReturnType()->isVoidTy())
            {
                // Add return to void function
                context->logger.logDebug(node->location, formatv("adding void return in {0}.{1}", context->getCurrentBlock()->getParent()->getName(), context->getCurrentBlock()->getName()));
                ReturnInst::Create(context->getLlvmContext(), context->getCurrentBlock());
            }
            else
            {
                context->logger.logDebug(node->location, formatv("missing return in {0}.{1}, adding one with block value", context->getCurrentBlock()->getParent()->getName(), context->getCurrentBlock()->getName()));
                ReturnInst::Create(context->getLlvmContext(), v.result, context->getCurrentBlock());
            }
        }

        context->popBlock();

        this->result = function;
    }

    void CodeGenVisitor::visit(ASTFunctionCall *node)
    {
        context->logger.logDebug(node->location, formatv("creating function call {0}", node->getId()->getFullName()));

        std::string moduleName = context->getModuleName();
        std::string functionName = node->getId()->getName();

        int memberCount = node->getId()->countNestedMembers();
        // If identifier has a member : then it is module.function
        Function *function = nullptr;
        if (memberCount == 1)
        {
            moduleName = node->getId()->getName();
            function = context->getLlvmModule()->getFunction(context->getMangler()->mangleFunctionName(node->getId()->getMember()->getName(), moduleName).c_str());
        }
        else
        {
            // Local module stark function
            function = context->getLlvmModule()->getFunction(context->getMangler()->mangleFunctionName(node->getId()->getName(), moduleName).c_str());

            // Try to find a runtime function
            if (function == nullptr)
            {
                function = context->getLlvmModule()->getFunction(context->getMangler()->manglePublicRuntimeFunctionName(node->getId()->getName()).c_str());
            }

            // Finally : look for an unmangled function
            if (function == nullptr)
            {
                function = context->getLlvmModule()->getFunction(node->getId()->getName().c_str());
            }
        }

        if (function == nullptr)
        {
            context->logger.logError(node->location, formatv("undeclared function {0}", node->getId()->getFullName()));
        }

        // Generate argument values
        std::vector<Value *> args;
        ASTExpressionList arguments = node->getArguments();

        if (function->arg_size() != node->getArguments().size())
        {
            context->logger.logError(node->location, formatv("function {0} is expecting {1} argument(s), not {2}", node->getId()->getFullName(), function->arg_size(), args.size()));
        }

        int i = 0;
        for (auto it = arguments.begin(); it != arguments.end(); it++)
        {
            Value *argVar = function->getArg(i);
            CodeGenVisitor v(context);
            (**it).accept(&v);

            // If value ids null : set the appropriate null constant
            Value *assignedValue = v.result;
            if (context->getChecker()->isNull(v.result))
            {
                assignedValue = ConstantPointerNull::getNullValue(argVar->getType());
            }

            args.push_back(assignedValue);
            i++;
        }

        // Check that function can be called
        context->getChecker()->checkAllowedFunctionCall(node->getId(), function, args);

        // Create call
        CallInst *call = CallInst::Create(function, makeArrayRef(args), function->getReturnType()->isVoidTy() ? "" : "call", context->getCurrentBlock());
        this->result = call;
    }

    void CodeGenVisitor::visit(ASTFunctionDeclaration *node)
    {
        context->logger.logDebug(node->location, formatv("creating function declaration for {0}", node->getId()->getFullName()));

        std::string moduleName = context->getModuleName();
        std::string functionName = node->getId()->getName();

        int memberCount = node->getId()->countNestedMembers();
        // If identifier has a member : then it is module.function
        if (memberCount == 1)
        {
            moduleName = node->getId()->getName();
            functionName = node->getId()->getMember()->getName();
        }
        // If more than one member : identifier is invalid
        else if (memberCount > 1)
        {
            context->logger.logError(node->location, formatv("invalid identifier {0} for function declaration, expecting <function name> or <module name>.<function name>", node->getId()->getFullName()));
        }

        // Mangle
        std::string mangledName = context->getMangler()->mangleFunctionName(functionName, moduleName);

        // Create external
        // TODO : get rid of this : create and evaluate ASTExternDeclaration nde instead
        this->result = createExternalDeclaration(mangledName, node->getArguments(), node->getType());
    }

    void CodeGenVisitor::visit(ASTExternDeclaration *node)
    {

        context->logger.logDebug(node->location, formatv("creating extern declaration for {0}", node->getId()->getName()));

        std::string functionName = node->getId()->getName();
        ASTVariableList arguments = node->getArguments();

        // Create external
        this->result = createExternalDeclaration(functionName, arguments, node->getType());
    }

    void CodeGenVisitor::visit(ASTReturnStatement *node)
    {

        context->logger.logDebug(node->location, formatv("generating return code {0}", typeid(node->getExpression()).name()));

        if (context->getCurrentBlock()->getTerminator() != nullptr)
        {
            context->logger.logError(node->location, "cannot add more than one terminator on a block");
        }

        CodeGenVisitor v(context);
        node->getExpression()->accept(&v);
        Value *returnValue = v.result;

        // Store return value
        context->setReturnValue(returnValue);

        this->result = returnValue;
    }

    void CodeGenVisitor::visit(ASTBinaryOperation *node)
    {

        context->logger.logDebug(node->location, formatv("creating binary operation {0}", node->getOp()));

        // Evaluate operands
        CodeGenVisitor vl(context);
        node->getLhs()->accept(&vl);
        CodeGenVisitor vr(context);
        node->getRhs()->accept(&vr);

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

        this->result = this->context->getPrimaryType(lhsTypeName)->createBinaryOperation(vl.result, node->getOp(), vr.result, node->location);
    }

    void CodeGenVisitor::visit(ASTComparison *node)
    {

        context->logger.logDebug(node->location, formatv("creating comparison {0}", node->getOp()));

        IRBuilder<> Builder(context->getLlvmContext());

        CodeGenVisitor vl(context);
        node->getLhs()->accept(&vl);
        CodeGenVisitor vr(context);
        node->getRhs()->accept(&vr);

        std::string lhsTypeName = context->getTypeName(vl.result->getType());
        std::string rhsTypeName = context->getTypeName(vr.result->getType());

        // Primary type
        if (context->isPrimaryType(lhsTypeName) && context->isPrimaryType(rhsTypeName))
        {
            // Operands must be of same type
            if (lhsTypeName.compare(rhsTypeName) != 0)
            {
                context->logger.logError(node->location, "cannot compare values of diffrent types");
            }

            this->result = this->context->getPrimaryType(lhsTypeName)->createComparison(vl.result, node->getOp(), vr.result, node->location);
        }
        // Complex type
        else
        {

            CodeGenComplexType *complexType = context->isPrimaryType(lhsTypeName) ? context->getComplexType(rhsTypeName) : context->getComplexType(lhsTypeName);

            this->result = complexType->createComparison(vl.result, node->getOp(), vr.result, node->location);
        }
    }

    void CodeGenVisitor::visit(ASTIfElseStatement *node)
    {

        context->logger.logDebug(node->location, "creating if else statement");

        // Used to know if else block should be generated
        bool generateElseBlock = (node->getFalseBlock() != nullptr && node->getFalseBlock()->getStatements().size() > 0);

        if (node->getTrueBlock()->getStatements().size() == 0 && !generateElseBlock)
        {
            return;
        }

        IRBuilder<> Builder(context->getLlvmContext());

        // Generate condition code
        CodeGenVisitor vc(context);
        node->getCondition()->accept(&vc);

        // Get the function of the current block fon instertion
        Function *currentFunction = context->getCurrentBlock()->getParent();

        // Create blocks (and insert if block)
        BasicBlock *ifBlock = BasicBlock::Create(context->getLlvmContext(), "if", currentFunction);
        BasicBlock *elseBlock = nullptr;
        if (generateElseBlock)
            elseBlock = BasicBlock::Create(context->getLlvmContext(), "else");
        BasicBlock *mergeBlock = BasicBlock::Create(context->getLlvmContext(), "ifcont");

        // Create condition
        Builder.SetInsertPoint(context->getCurrentBlock());
        // If/else or simple if
        Value *condition = Builder.CreateCondBr(vc.result, ifBlock, generateElseBlock ? elseBlock : mergeBlock);

        // Generate if block
        context->pushBlock(ifBlock, true);

        CodeGenVisitor vt(context);
        node->getTrueBlock()->accept(&vt);

        // Add branch to merge block
        Builder.SetInsertPoint(context->getCurrentBlock());
        if (context->getReturnValue() != nullptr)
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
            node->getFalseBlock()->accept(&vf);

            // Add branch to merge block
            Builder.SetInsertPoint(context->getCurrentBlock());
            if (context->getReturnValue() != nullptr)
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
            if (node->getTrueBlock()->getStatements().size() > 0 && vt.result != nullptr && !vt.result->getType()->isVoidTy())
            {
                PN->addIncoming(vt.result, ifBlock);
            }

            if (generateElseBlock && vf.result != nullptr && !vf.result->getType()->isVoidTy())
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
        if (node->getBlock()->getStatements().size() == 0)
        {
            return;
        }

        IRBuilder<> Builder(context->getLlvmContext());

        // Get the function of the current block fon instertion
        Function *currentFunction = context->getCurrentBlock()->getParent();

        // Create blocks (and insert if block)
        BasicBlock *whileTestBlock = BasicBlock::Create(context->getLlvmContext(), "whiletest", currentFunction);
        BasicBlock *whileBlock = BasicBlock::Create(context->getLlvmContext(), "while");
        BasicBlock *mergeBlock = BasicBlock::Create(context->getLlvmContext(), "whilecont");

        // Branch to test block
        Builder.SetInsertPoint(context->getCurrentBlock());
        Builder.CreateBr(whileTestBlock);

        // Generate test block ------------------------
        context->pushBlock(whileTestBlock, true);

        // Generate condition code
        CodeGenVisitor vc(context);
        node->getCondition()->accept(&vc);

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
        node->getBlock()->accept(&vb);

        // Create branch to test block, or return
        Builder.SetInsertPoint(context->getCurrentBlock());
        if (context->getReturnValue() != nullptr)
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
        context->logger.logDebug(node->location, formatv("creating struct declaration {0}", node->getId()->getFullName()));

        context->getChecker()->checkAllowedTypeDeclaration(node->getId());

        CodeGenComplexType *structType = new CodeGenComplexType(node->getId()->getFullName(), context);
        ASTVariableList arguments = node->getArguments();
        ASTVariableList::const_iterator it;
        for (it = arguments.begin(); it != arguments.end(); it++)
        {
            structType->addMember((**it).getId()->getName(), (**it).getType()->getFullName(), typeOf(*((**it).getType()), context), (**it).isArray());
        }
        context->declareComplexType(structType);
    }

    void CodeGenVisitor::visit(ASTTypeConversion *node)
    {
        context->logger.logDebug(node->location, formatv("creating type convertion to type {0}", node->getType()->getFullName()));

        // Evaluate expression
        CodeGenVisitor v(context);
        node->getExpression()->accept(&v);

        std::string exprTypeName = context->getTypeName(v.result->getType());

        // Type conversion is not suported on complex types
        if (context->isPrimaryType(exprTypeName))
        {
            this->result = context->getPrimaryType(exprTypeName)->convert(v.result, node->getType()->getFullName(), node->location);
        }
        else
        {
            this->result = context->getComplexType(exprTypeName)->convert(v.result, node->getType()->getFullName(), node->location);
        }
    }

    void CodeGenVisitor::visit(ASTModuleDeclaration *node)
    {
        // Module declaration must be delcared as first statement of a file : it should be never directly visited !
        context->logger.logError(node->location, "module declaration is only supported as first statement of a file");
    }

    void CodeGenVisitor::visit(ASTImportDeclaration *node)
    {
        // Does not generate any code
        // Import declaration is only allowed on root

        // TODO: make sure that the imported module was not already imported !
        // And that identifier format is ok
        // >> add a check

        // Compiler mode
        if (!context->isInterpreterMode())
        {
            bool isOnRoot = context->getCurrentBlock() == nullptr;
            if (!isOnRoot)
            {
                context->logger.logError(node->location, "import declaration is not allowed inside a block");
            }
        }
        // Interpreter mode
        else
        {
            bool isInMain = context->getCurrentBlock()->getParent()->getName().compare(MAIN_FUNCTION_NAME) == 0;
            if (!isInMain)
            {
                context->logger.logError(node->location, "import declaration is not allowed inside a block");
            }
        }

        context->addImportedModuleName(node->getId()->getFullName());
    }

} // namespace stark