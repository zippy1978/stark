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
#include "CodeGenFileContext.h"
#include "CodeGenVisitor.h"
#include "CodeGenFunctionHelper.h"

using namespace std;

namespace stark
{

    FunctionType *CodeGenFunctionHelper::createFunctionType(ASTFunctionSignature *signature)
    {

        // If no return type : void is assumed
        Type *returnType;
        if (signature->getType() == nullptr)
        {
            returnType = context->getPrimaryType("void")->getType();
        }
        else
        {

            returnType = context->getType(signature->getType()->getFullName());

            // Array case
            if (signature->getType()->isArray())
            {
                returnType = context->getArrayComplexType(signature->getType()->getFullName())->getType()->getPointerTo();
            }

            // Complex types are pointers !
            if (!context->isPrimaryType(signature->getType()->getFullName()) && !signature->getType()->isArray())
            {
                returnType = returnType->getPointerTo();
            }
        }

        // Build parameters
        ASTIdentifierList arguments = signature->getArguments();
        vector<Type *> argTypes;
        for (auto it = arguments.begin(); it != arguments.end(); it++)
        {
            ASTIdentifier *id = *it;
            Type *type = context->getType(id->getFullName());
            if (id->isArray())
            {
                type = context->getArrayComplexType(id->getFullName())->getType()->getPointerTo();
            }

            if (type == nullptr)
            {
                context->logger.logError(id->location, formatv("unknown type {0}", id->getFullName()));
            }

            // Complex types are pointer variables !
            if (!context->isPrimaryType(id->getFullName()) && !id->isArray())
            {
                type = type->getPointerTo();
            }

            argTypes.push_back(type);
        }

        return FunctionType::get(returnType, makeArrayRef(argTypes), false);
    }

    Function *CodeGenFunctionHelper::createExternalDeclaration(std::string functionName, ASTVariableList arguments, ASTIdentifier *type)
    {
        vector<Type *> argTypes = this->checkAndExtractArgumentTypes(arguments);

        Type *returnType;
        if (type == nullptr)
        {
            returnType = context->getPrimaryType("void")->getType();
        }
        else
        {
            returnType = type->isArray() ? context->getArrayComplexType(type->getFullName())->getType()->getPointerTo() : context->getType(type->getFullName());

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

    vector<Type *> CodeGenFunctionHelper::checkAndExtractArgumentTypes(ASTVariableList arguments)
    {
        vector<Type *> argTypes;
        for (auto it = arguments.begin(); it != arguments.end(); it++)
        {
            ASTVariableDeclaration *v = *it;
            Type *type = nullptr;

            // Types
            if (v->getType() != nullptr)
            {
                type = context->getType(v->getType()->getFullName());
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
            }
            // Function signatures
            else
            {
                CodeGenFunctionType *ft = context->declareFunctionType(v->getFunctionSignature());
                type = ft->getType()->getPointerTo();

                if (v->isArray())
                {
                    type = context->getArrayComplexType(ft->getName())->getType()->getPointerTo();
                }
            }

            argTypes.push_back(type);
        }

        return argTypes;
    }

    Type *CodeGenFunctionHelper::getReturnType(ASTIdentifier *id)
    {
        Type *result = context->getPrimaryType("void")->getType();
        if (id != nullptr)
        {

            result = context->getType(id->getFullName());

            // Array case
            if (id->isArray())
            {
                result = context->getArrayComplexType(id->getFullName())->getType()->getPointerTo();
            }

            // Complex types are pointers !
            if (!context->isPrimaryType(id->getFullName()) && !id->isArray())
            {
                result = result->getPointerTo();
            }
        }

        return result;
    }

    void CodeGenFunctionHelper::expandMainArgs(Function *function, std::string mainArgsParameterName, BasicBlock *block)
    {
        Function::arg_iterator argsValues = function->arg_begin();

        // Create variable
        std::string typeName = "string";
        CodeGenVariable *var = new CodeGenVariable(mainArgsParameterName, typeName, true, context->getArrayComplexType(typeName)->getType()->getPointerTo());
        context->declareLocal(var);

        // Call runtime function to create args string[]
        Function *extractFunction = context->getLlvmModule()->getFunction(STARK_RUNTIME_EXTRACT_ARGS_FUNCTION);
        if (extractFunction == nullptr)
        {
            context->logger.logError("cannot extract main args: cannot find runtime function");
        }
        std::vector<Value *> args;
        args.push_back(&*argsValues++);
        args.push_back(&*argsValues++);
        Value *alloc = CallInst::Create(extractFunction, makeArrayRef(args), "argsalloc", block);
        StoreInst *inst = new StoreInst(alloc, var->getValue(), false, block);
    }

    void CodeGenFunctionHelper::expandLocalVariables(Function *function, ASTVariableList arguments, BasicBlock *block)
    {
        Function::arg_iterator argsValues = function->arg_begin();

        for (auto it = arguments.begin(); it != arguments.end(); it++)
        {
            ASTVariableDeclaration *vd = (*it);
            CodeGenVisitor v(context);
            vd->accept(&v);

            Value *argumentValue = &*argsValues++;
            argumentValue->setName(vd->getId()->getName().c_str());
            Value *varValue = context->getLocal(vd->getId()->getName())->getValue();
            StoreInst *inst = new StoreInst(argumentValue, varValue, false, block);
        }
    }

    bool CodeGenFunctionHelper::isMainFunctionWithArgs(std::string functionName, vector<Type *> argumentTypes)
    {
        bool result = false;

        // It is the main function with one argument
        if (argumentTypes.size() == 1 && functionName.compare(MAIN_FUNCTION_NAME) == 0)
        {
            // Its argument is a stirng array
            CodeGenComplexType *stringArrayType = context->getArrayComplexType("string");
            if (context->getTypeName(stringArrayType->getType()).compare(context->getTypeName(argumentTypes[0])) == 0)
            {
                result = true;
            }
        }

        return result;
    }

    vector<Type *> CodeGenFunctionHelper::getMainArgumentTypes()
    {
        vector<Type *> result;
        result.push_back(context->getPrimaryType("int")->getType());
        result.push_back(context->getPrimaryType("any")->getType());
        return result;
    }

    void CodeGenFunctionHelper::createReturn(Function *function, Value* value, BasicBlock *block)
    {
        // If no return : add a default one
        if (context->getReturnValue() != nullptr)
        {
            ReturnInst::Create(context->getLlvmContext(), context->getReturnValue(), block);
        }
        else
        {
            if (function->getReturnType()->isVoidTy())
            {
                // Add return to void function
                context->logger.logDebug(formatv("adding void return in {0}.{1}", function->getName(), block->getName()));
                ReturnInst::Create(context->getLlvmContext(), block);
            }
            else
            {
                context->logger.logDebug(formatv("missing return in {0}.{1}, adding one with block value", function->getName(), block->getName()));
                ReturnInst::Create(context->getLlvmContext(), value, block);
            }
        }
    }

    StructType *CodeGenFunctionHelper::createClosureEnvironment(std::vector<CodeGenVariable *> variables)
    {
        // Generate anonymous name
        std::string name = context->getMangler()->mangleAnonymousStructName(context->getNextAnonymousId(), context->getModuleName(), context->getFilename());

        vector<Type *> memberTypes;
        for (auto it = std::begin(variables); it != std::end(variables); ++it)
        {
            CodeGenVariable *v = *it;
            if (v->isArray())
            {
                // Array case : must use the matching array complex type
                memberTypes.push_back(context->getArrayComplexType(v->getTypeName())->getType()->getPointerTo());
            }
            else
            {
                memberTypes.push_back(v->getType());
            }
        }

        // Build and store struct type
        return StructType::create(context->getLlvmContext(), memberTypes, name, false);
    }

} // namespace stark