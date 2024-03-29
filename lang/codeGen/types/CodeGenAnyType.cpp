#include <llvm/IR/Constants.h>
#include <llvm/IR/IRBuilder.h>

#include "CodeGenPrimaryType.h"
#include "../CodeGenFileContext.h"

namespace stark
{
    CodeGenAnyType::CodeGenAnyType(CodeGenFileContext *context) : CodeGenPrimaryType("any", context, Type::getInt8PtrTy(context->getLlvmContext()), "i8*") {}

    Value *CodeGenAnyType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs)
    {
        IRBuilder<> Builder(context->getLlvmContext());
        Builder.SetInsertPoint(context->getCurrentBlock());

        switch (op)
        {
        case EQ:
            return Builder.CreateICmpEQ(lhs, rhs, "cmp");
            break;
        case NE:
            return Builder.CreateICmpNE(lhs, rhs, "cmp");
            break;
        case LT:
        case LE:
        case GT:
        case GE:
        default:
            break;
        }

        context->logger.logError(context->getCurrentLocation(), formatv("unsupported comparison for type {0}", this->name));
        return nullptr;
    }

    Value *CodeGenAnyType::createDefaultValue()
    {
        // Default value for any type is null
        return ConstantPointerNull::getNullValue(type->getPointerTo());
    }

} // namespace stark