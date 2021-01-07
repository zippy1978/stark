#include <vector>

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
        if (type != NULL)
        {
            return;
        }

        // Generate member types
        vector<Type *> memberTypes;
        for (auto it = std::begin(members); it != std::end(members); ++it)
        {
            CodeGenComplexTypeMember *m = *it;
            memberTypes.push_back(m->type);
        }

        // Build and store struct type
        type = StructType::create(*llvmContext, memberTypes, name, false);
    }

    CodeGenComplexTypeMember *CodeGenComplexType::getMember(std::string name)
    {
        for (auto it = std::begin(members); it != std::end(members); ++it)
        {
            CodeGenComplexTypeMember *m = *it;
            if (m->name.compare(name) == 0) {
                return m;
            }
        }

        return NULL;
    }

} // namespace stark