#include <vector>

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
        context->logger.logError(location, formatv("cannot covert type {0} to type {1}", this->name, typeName));
        return nullptr;
    }

} // namespace stark