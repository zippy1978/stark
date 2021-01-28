#include <llvm/IR/Constants.h>
#include <llvm/IR/IRBuilder.h>

#include "CodeGenPrimaryType.h"
#include "../CodeGenContext.h"

namespace stark
{

    CodeGenVoidType::CodeGenVoidType(CodeGenContext *context) : CodeGenPrimaryType("void", context, Type::getVoidTy(context->llvmContext), "void") {}
    CodeGenAnyType::CodeGenAnyType(CodeGenContext *context) : CodeGenPrimaryType("any", context, Type::getInt8PtrTy(context->llvmContext), "i8*") {}

    Value *CodeGenPrimaryType::convert(Value *value, std::string typeName)
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

    Value *CodeGenPrimaryType::create(long long i, FileLocation location)
    {
        context->logger.logError(location, formatv("cannot create constant of type {0} with value {1}", this->name, i));
        return NULL;
    }

    Value *CodeGenPrimaryType::create(double d, FileLocation location)
    {
        context->logger.logError(location, formatv("cannot create constant of type {0} with value {1}", this->name, d));
        return NULL;
    }
    Value *CodeGenPrimaryType::create(bool b, FileLocation location)
    {
        context->logger.logError(location, formatv("cannot create constant of type {0} with value {1}", this->name, b));
        return NULL;
    }

    Value *CodeGenPrimaryType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs, FileLocation location)
    {
        context->logger.logError(location, formatv("unsupported binary operation for type {0}", this->name));
        return NULL;
    }

    Value *CodeGenPrimaryType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs, FileLocation location)
    {
        context->logger.logError(location, formatv("unsupported comparison for type {0}", this->name));
        return NULL;
    }

} // namespace stark