#include <llvm/IR/Constants.h>
#include <llvm/IR/IRBuilder.h>

#include "CodeGenClosureType.h"
#include "../CodeGenFileContext.h"

namespace stark
{
    void CodeGenClosureType::declare()
    {
        // If type already exists
        // declaration was already done
        // exiting
        if (type != nullptr)
        {
            return;
        }

        // Generate member types
        std::vector<Type *> memberTypes;
        memberTypes.push_back(context->getPrimaryType("any")->getType());
        memberTypes.push_back(functionType->getType()->getPointerTo());

        // Build and store struct type
        type = StructType::create(context->getLlvmContext(), memberTypes, name, false);
    }

    Value *CodeGenClosureType::create(Function *function, StructType *environement)
    {
        // TODO
        return nullptr;
    }

} // namespace stark