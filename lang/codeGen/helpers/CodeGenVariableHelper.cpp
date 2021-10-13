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
#include "CodeGenVariableHelper.h"

using namespace std;
using namespace llvm;

namespace stark
{
    CodeGenVariable *CodeGenVariableHelper::createVariable(ASTVariableDeclaration *variableDeclaration)
    {
        std::string typeName;
        Type *type;
        bool isFunction;
        bool isArray;

        // Variable Type
        if (variableDeclaration->getType() != nullptr)
        {
            typeName = variableDeclaration->getType()->getFullName();
            type = context->getTypeHelper()->getType(variableDeclaration->getType());
            isArray = variableDeclaration->getType()->isArray();
            isFunction = false;
        }
        // Function signature type
        else
        {
            type = context->getTypeHelper()->getType(variableDeclaration->getFunctionSignature());
            typeName = context->getTypeName(type);
            isArray = variableDeclaration->getFunctionSignature()->isArray();
            isFunction = true;
        }

        CodeGenVariable *var = new CodeGenVariable(variableDeclaration->getId()->getName(), typeName, isArray, type);
        var->setFunction(isFunction);
        context->declareLocal(var);

        return var;
    }

    Value *CodeGenVariableHelper::createDefaultValue(CodeGenVariable *variable)
    {
        Value *result;

        // Function signature type
        if (variable->isFunction())
        {
            result = ConstantPointerNull::getNullValue(variable->getType()->getPointerTo());
        }
        // Types
        else
        { 
            result = context->isPrimaryType(variable->getTypeName()) ? context->getPrimaryType(variable->getTypeName())->createDefaultValue() : variable->isArray() ? context->getArrayComplexType(variable->getTypeName())->createDefaultValue()
                                                                                                                                                 : context->getComplexType(variable->getTypeName())->createDefaultValue();
        }

        return result;
    }

} // namespace stark