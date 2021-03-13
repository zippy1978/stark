#include <llvm/IR/Constants.h>
#include <llvm/IR/IRBuilder.h>

#include "CodeGenPrimaryType.h"
#include "../CodeGenFileContext.h"

namespace stark
{

    CodeGenVoidType::CodeGenVoidType(CodeGenFileContext *context) : CodeGenPrimaryType("void", context, Type::getVoidTy(context->getLlvmContext()), "void") {}

    Value *CodeGenPrimaryType::convert(Value *value, std::string typeName)
    {
        if (typeName.compare(this->name) == 0)
        {
            return value;
        }
        else
        {
            context->logger.logError(context->getCurrentLocation(), formatv("conversion from {0} to {1} is not supported", this->name, typeName));
            return nullptr;
        }
    }

    Value *CodeGenPrimaryType::create(long long i)
    {
        context->logger.logError(context->getCurrentLocation(), formatv("cannot create constant of type {0} with value {1}", this->name, i));
        return nullptr;
    }

    Value *CodeGenPrimaryType::create(double d)
    {
        context->logger.logError(context->getCurrentLocation(), formatv("cannot create constant of type {0} with value {1}", this->name, d));
        return nullptr;
    }
    Value *CodeGenPrimaryType::create(bool b)
    {
        context->logger.logError(context->getCurrentLocation(), formatv("cannot create constant of type {0} with value {1}", this->name, b));
        return nullptr;
    }

    Value *CodeGenPrimaryType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs)
    {
        context->logger.logError(context->getCurrentLocation(), formatv("unsupported binary operation for type {0}", this->name));
        return nullptr;
    }

    Value *CodeGenPrimaryType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs)
    {
        context->logger.logError(context->getCurrentLocation(), formatv("unsupported comparison for type {0}", this->name));
        return nullptr;
    }

} // namespace stark