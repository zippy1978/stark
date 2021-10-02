#include "CodeGenFileContext.h"
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
        ASTVariableList arguments = signature->getArguments();
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

        return FunctionType::get(returnType, makeArrayRef(argTypes), false);
    }

    Function *CodeGenFunctionHelper::createExternalDeclaration(std::string functionName, ASTVariableList arguments, ASTIdentifier *type)
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
                type = context->getFunctionHelper()->createFunctionType(v->getFunctionSignature())->getPointerTo();
            }

            argTypes.push_back(type);
        }

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

} // namespace stark