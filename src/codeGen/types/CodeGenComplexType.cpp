#include <vector>
#include <llvm/IR/Constant.h>
#include <llvm/IR/IRBuilder.h>

#include "../CodeGenFileContext.h"
#include "CodeGenComplexType.h"

using namespace llvm;
using namespace std;

namespace stark
{
    void CodeGenComplexType::declare()
    {
        // If type already exists
        // declaration was already done
        // exiting
        if (type != nullptr)
        {
            return;
        }

        // Generate member types
        vector<Type *> memberTypes;
        for (auto it = std::begin(members); it != std::end(members); ++it)
        {
            CodeGenComplexTypeMember *m = it->get();
            if (m->array)
            {
                // Array case : must use the matching array complex type
                memberTypes.push_back(context->getArrayComplexType(m->typeName)->getType());
            }
            else
            {
                memberTypes.push_back(m->type);
            }
        }

        // Build and store struct type
        type = StructType::create(context->getLlvmContext(), memberTypes, name, false);
    }

    CodeGenComplexTypeMember *CodeGenComplexType::getMember(std::string name)
    {
        for (auto it = std::begin(members); it != std::end(members); ++it)
        {
            CodeGenComplexTypeMember *m = it->get();
            if (m->name.compare(name) == 0)
            {
                return m;
            }
        }

        return nullptr;
    }

    Value *CodeGenComplexType::create(std::vector<Value *> values, FileLocation location)
    {
        return nullptr;
    }

    Value *CodeGenComplexType::create(std::string string, FileLocation location)
    {
        return nullptr;
    }

    Value *CodeGenComplexType::convert(Value *value, std::string typeName, FileLocation location)
    {
        if (typeName.compare("any") == 0)
        {
            return new BitCastInst(value, context->getPrimaryType("any")->getType(), "", context->getCurrentBlock());
        }
        else
        {
            context->logger.logError(location, formatv("cannot convert type {0} to type {1}", this->name, typeName));
            return nullptr;
        }
    }

    Value *CodeGenComplexType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs, FileLocation location)
    {
        // Complex types can only be compared to null with == or != operators

        std::string lhsTypeName = context->getTypeName(lhs->getType());
        std::string rhsTypeName = context->getTypeName(rhs->getType());

        if (context->getChecker()->isNull(lhs) || context->getChecker()->isNull(rhs))
        {
            if (context->isPrimaryType(lhsTypeName) || context->isPrimaryType(rhsTypeName))
            {
                IRBuilder<> Builder(context->getLlvmContext());
                Builder.SetInsertPoint(context->getCurrentBlock());

                Value *lhsPointer;
                Value *rhsPointer;
                // Null is lhs
                if (context->isPrimaryType(lhsTypeName))
                {
                    lhsPointer = lhs;
                    rhsPointer = Builder.CreateBitCast(rhs, rhs->getType()->getPointerTo());
                }
                // Null is rhs
                else
                {
                    lhsPointer = Builder.CreateBitCast(lhs, lhs->getType()->getPointerTo());
                    rhsPointer = rhs;
                }

                switch (op)
                {
                case EQ:
                    return Builder.CreateICmpEQ(lhsPointer, rhsPointer, "cmp");
                    break;
                case NE:
                    return Builder.CreateICmpNE(lhsPointer, rhsPointer, "cmp");
                    break;
                }
            }
        }

        context->logger.logError(location, "comparison not supported");
        return nullptr;
    }

} // namespace stark