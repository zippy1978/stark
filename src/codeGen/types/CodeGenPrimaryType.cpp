#include <llvm/IR/Constants.h>

#include "CodeGenPrimaryType.h"
#include "../CodeGenContext.h"

namespace stark
{
    CodeGenIntType::CodeGenIntType(CodeGenContext *context) : CodeGenPrimaryType("int", context, Type::getInt64Ty(context->llvmContext), "i64") {}
    CodeGenDoubleType::CodeGenDoubleType(CodeGenContext *context) : CodeGenPrimaryType("double", context, Type::getDoubleTy(context->llvmContext), "double") {}
    CodeGenBoolType::CodeGenBoolType(CodeGenContext *context) : CodeGenPrimaryType("bool", context, Type::getInt1Ty(context->llvmContext), "i1") {}
    CodeGenVoidType::CodeGenVoidType(CodeGenContext *context) : CodeGenPrimaryType("void", context, Type::getVoidTy(context->llvmContext), "void") {}
    CodeGenAnyType::CodeGenAnyType(CodeGenContext *context) : CodeGenPrimaryType("any", context, Type::getInt8PtrTy(context->llvmContext), "i8*") {}

    Value *CodeGenPrimaryType::cast(Value *value, std::string typeName)
    {
        if (typeName.compare(this->name) == 0)
        {
            return value;
        }
        else
        {
            context->logger.logError(formatv("cast from {0} to {1} is not supported", this->name, typeName));
            return NULL;
        }
    }

    Value *CodeGenPrimaryType::createConstant(long long i)
    {
        context->logger.logError(formatv("cannot create constant of type {0} with value {1}", this->name, i));
        return NULL;
    }

    Value *CodeGenPrimaryType::createConstant(double d)
    {
        context->logger.logError(formatv("cannot create constant of type {0} with value {1}", this->name, d));
        return NULL;
    }
    Value *CodeGenPrimaryType::createConstant(bool b)
    {
        context->logger.logError(formatv("cannot create constant of type {0} with value {1}", this->name, b));
        return NULL;
    }

    Value *CodeGenIntType::createConstant(long long i)
    {

        return ConstantInt::get(this->getType(), i);
    }

    Value *CodeGenDoubleType::createConstant(double d)
    {

        return ConstantFP::get(this->getType(), d);
    }

    Value *CodeGenBoolType::createConstant(bool b)
    {

        return ConstantInt::get(this->getType(), b);
    }

} // namespace stark