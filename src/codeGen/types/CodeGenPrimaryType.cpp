#include <llvm/IR/Constants.h>
#include <llvm/IR/IRBuilder.h>

#include "CodeGenPrimaryType.h"
#include "../CodeGenFileContext.h"

namespace stark
{

    CodeGenVoidType::CodeGenVoidType(CodeGenFileContext *context) : CodeGenPrimaryType("void", context, Type::getVoidTy(context->getLlvmContext()), "void") {}
    CodeGenAnyType::CodeGenAnyType(CodeGenFileContext *context) : CodeGenPrimaryType("any", context, Type::getInt8PtrTy(context->getLlvmContext()), "i8*") {}

    Value *CodeGenPrimaryType::convert(Value *value, std::string typeName, FileLocation location)
    {
        if (typeName.compare(this->name) == 0)
        {
            return value;
        }
        else
        {
            context->logger.logError(location, formatv("conversion from {0} to {1} is not supported", this->name, typeName));
            return nullptr;
        }
    }

    Value *CodeGenPrimaryType::create(long long i, FileLocation location)
    {
        context->logger.logError(location, formatv("cannot create constant of type {0} with value {1}", this->name, i));
        return nullptr;
    }

    Value *CodeGenPrimaryType::create(double d, FileLocation location)
    {
        context->logger.logError(location, formatv("cannot create constant of type {0} with value {1}", this->name, d));
        return nullptr;
    }
    Value *CodeGenPrimaryType::create(bool b, FileLocation location)
    {
        context->logger.logError(location, formatv("cannot create constant of type {0} with value {1}", this->name, b));
        return nullptr;
    }

    Value *CodeGenPrimaryType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs, FileLocation location)
    {
        context->logger.logError(location, formatv("unsupported binary operation for type {0}", this->name));
        return nullptr;
    }

    Value *CodeGenPrimaryType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs, FileLocation location)
    {
        context->logger.logError(location, formatv("unsupported comparison for type {0}", this->name));
        return nullptr;
    }

} // namespace stark