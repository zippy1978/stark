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

#include "../CodeGenConstants.h"
#include "../CodeGenFileContext.h"
#include "../CodeGenVisitor.h"
#include "CodeGenFunctionHelper.h"

using namespace std;
using namespace llvm;

namespace stark
{

    FunctionType *CodeGenFunctionHelper::createFunctionType(ASTFunctionSignature *signature)
    {

        
        Type *returnType;
        if (signature->getType() == nullptr)
        {
            // Function signature
            if (signature->getFunctionSignature() != nullptr)
            {
                returnType = context->declareFunctionType(signature->getFunctionSignature())->getType()->getPointerTo();
            }
            // If no return type : void is assumed
            else
            {
                returnType = context->getPrimaryType("void")->getType();
            }
        }
        // Type
        else
        {
            returnType = context->getTypeHelper()->getType(signature->getType());
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

    std::string CodeGenFunctionHelper::checkAndGenerateMangledFunctionName(ASTFunctionDeclaration *functionDeclaration)
    {
        std::string functionName;
        std::string moduleName = context->getModuleName();
        bool anonymous = functionDeclaration->getId() == nullptr;

        // Anonymous function : generate a name
        if (anonymous)
        {
            functionName = context->getMangler()->mangleAnonymousFunctionName(context->getNextAnonymousId(), context->getModuleName(), context->getFilename());
        }
        else
        {
            functionName = functionDeclaration->getId()->getName();

            int memberCount = functionDeclaration->getId()->countNestedMembers();
            // If identifier has a member : then it is module.function
            if (memberCount == 1)
            {
                if (functionDeclaration->getBlock() == nullptr)
                {
                    moduleName = functionDeclaration->getId()->getName();
                    functionName = functionDeclaration->getId()->getMember()->getName();
                }
                // Function with body (definition) cannot have multiple members in identifier
                else
                {
                    context->logger.logError(functionDeclaration->location, formatv("invalid identifier {0} for function declaration, expecting <function name> or <module name>.<function name>", functionDeclaration->getId()->getFullName()));
                }
            }
            // If more than one member : identifier is invalid
            else if (memberCount > 1)
            {
                context->logger.logError(functionDeclaration->location, formatv("invalid identifier {0} for function declaration, expecting <function name> or <module name>.<function name>", functionDeclaration->getId()->getFullName()));
            }
        }

        // Naming
        // Check declaration (if it is a definition)
        if (functionDeclaration->getBlock() != nullptr && !anonymous)
        {
            context->getChecker()->checkAllowedFunctionDeclaration(functionDeclaration->getId());
        }
        // If not an external declaration : mangle name
        if (!functionDeclaration->isExternal())
        {
            functionName = context->getMangler()->mangleFunctionName(functionName, moduleName);
        }

        return functionName;
    }

    Function *CodeGenFunctionHelper::createFunctionDeclaration(ASTFunctionDeclaration *functionDeclaration)
    {
        bool anonymous = functionDeclaration->getId() == nullptr;

        // Generate valid name
        std::string functionName = this->checkAndGenerateMangledFunctionName(functionDeclaration);

        // Extract arguments
        vector<Type *> argTypes = this->checkAndExtractArgumentTypes(functionDeclaration->getArguments());

        // Test if function is main with args: string[] as single parameter
        bool isMainWithArgs = context->getFunctionHelper()->isMainFunctionWithArgs(functionName, argTypes);

        std::string mainArgsParameterName = "args";
        if (isMainWithArgs)
        {
            mainArgsParameterName = functionDeclaration->getArguments()[0]->getId()->getFullName();

            // Replace arg types with argc & argv
            argTypes = context->getFunctionHelper()->getMainArgumentTypes();
        }

        // Determine return type
        Type *returnType = context->getFunctionHelper()->getReturnType(functionDeclaration);

        // Create function
        FunctionType *ftype = FunctionType::get(returnType, makeArrayRef(argTypes), false);
        // TODO : being able to change function visibility by changing ExternalLinkage
        // See https://llvm.org/docs/LangRef.html
        Function *function = Function::Create(ftype, anonymous ? GlobalValue::InternalLinkage : GlobalValue::ExternalLinkage, functionName.c_str(), context->getLlvmModule());

        // Block
        if (functionDeclaration->getBlock() != nullptr)
        {

            BasicBlock *bblock = BasicBlock::Create(context->getLlvmContext(), "entry", function, 0);
            context->pushBlock(bblock);

            // If main function with args: create args local variable
            if (isMainWithArgs)
            {
                context->getFunctionHelper()->expandMainArgs(function, mainArgsParameterName, context->getCurrentBlock());
            }
            // Otherwise: create local variables for each argument
            else
            {
                context->getFunctionHelper()->expandLocalVariables(function, functionDeclaration->getArguments(), context->getCurrentBlock());
            }

            // When not running in interpreter mode : try init memory manager
            // (must be done after the begining of the main function)
            if (!context->isInterpreterMode())
            {
                context->initMemoryManager();
            }

            // Evaluate block
            CodeGenVisitor v(context);
            functionDeclaration->getBlock()->accept(&v);

            // Add return at the end.
            context->getFunctionHelper()->createReturn(function, v.result, context->getCurrentBlock());

            context->popBlock();
        }
        else
        {
            // If in interpreter mode : try to init the memory manager
            // as soon as the required runtime function is declared
            if (context->isInterpreterMode())
            {
                context->initMemoryManager();
            }
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
                if (v->getType()->isArray())
                {
                    type = context->getArrayComplexType(v->getType()->getFullName())->getType()->getPointerTo();
                }

                if (type == nullptr)
                {
                    context->logger.logError(v->location, formatv("unknown type {0}", v->getType()->getFullName()));
                }

                // Complex types are pointer variables !
                if (!context->isPrimaryType(v->getType()->getFullName()) && !v->getType()->isArray())
                {
                    type = type->getPointerTo();
                }
            }
            // Function signatures
            else
            {
                CodeGenFunctionType *ft = context->declareFunctionType(v->getFunctionSignature());
                type = ft->getType()->getPointerTo();

                if (v->getFunctionSignature()->isArray())
                {
                    type = context->getArrayComplexType(ft->getName())->getType()->getPointerTo();
                }
            }

            argTypes.push_back(type);
        }

        return argTypes;
    }

    Type *CodeGenFunctionHelper::getReturnType(ASTFunctionDeclaration *functionDeclaration)
    {
        ASTWriter w;

        Type *result = context->getPrimaryType("void")->getType();
        ASTIdentifier *typeId = functionDeclaration->getType();
        ASTFunctionSignature *signatureType = functionDeclaration->getFunctionSignatureType();
        // Type
        if (typeId != nullptr)
        {

            result = context->getType(typeId->getFullName());

            // Array case
            if (typeId->isArray())
            {
                result = context->getArrayComplexType(typeId->getFullName())->getType()->getPointerTo();
            }

            // Complex types are pointers !
            if (!context->isPrimaryType(typeId->getFullName()) && !typeId->isArray())
            {
                result = result->getPointerTo();
            }
        }
        // Signature type
        else if (signatureType != nullptr)
        {
            // Signatures are pointers
            result = context->declareFunctionType(signatureType)->getType()->getPointerTo();
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

    void CodeGenFunctionHelper::createReturn(Function *function, Value *value, BasicBlock *block)
    {
        // If no return : add a default one
        if (context->getReturnValue() != nullptr)
        {
            // Type *actualType = context->getReturnValue()->getType
            if (!context->getChecker()->canAssign(context->getReturnValue(), context->getTypeName(function->getReturnType())))
            {
                context->logger.logError(formatv("function is expecting {0} type as return type, not {1}", context->getTypeName(function->getReturnType()), context->getTypeName(context->getReturnValue()->getType())));
            }

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