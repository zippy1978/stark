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
        
        // TODO
        /*for (auto it = std::begin(members); it != std::end(members); ++it)
        {
            CodeGenComplexTypeMember *m = it->get();
            if (m->array)
            {
                // Array case : must use the matching array complex type
                memberTypes.push_back(context->getArrayComplexType(m->typeName)->getType()->getPointerTo());
            }
            else
            {
                memberTypes.push_back(m->type);
            }
        }*/

        // Build and store struct type
        type = StructType::create(context->getLlvmContext(), memberTypes, name, false);
    }

    Value *CodeGenClosureType::create(Function *function, StructType *environement)
    {
        // TODO
        return nullptr;
    }

} // namespace stark