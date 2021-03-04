#include <llvm/IR/Constants.h>
#include <llvm/IR/IRBuilder.h>

#include "CodeGenPrimaryType.h"
#include "../CodeGenFileContext.h"

namespace stark
{
    CodeGenAnyType::CodeGenAnyType(CodeGenFileContext *context) : CodeGenPrimaryType("any", context, Type::getInt8PtrTy(context->getLlvmContext()), "i8*") {}

    Value *CodeGenAnyType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs, FileLocation location)
    {
        // Edge case : null with null comparison
        if (context->getChecker()->isNull(lhs) && context->getChecker()->isNull(rhs))
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
            }
        }
        else
        {
            context->logger.logError(location, formatv("unsupported comparison for type {0}", this->name));
        }
        return nullptr;
    }

} // namespace stark