#include <vector>
#include <llvm/IR/Instructions.h>

#include "CodeGenVariable.h"

using namespace llvm;
using namespace std;

namespace stark
{
    void CodeGenVariable::declare(BasicBlock *block)
    {

        // If value already exists
        // declaration was already done
        // exiting
        if (value != NULL)
        {
            return;
        }

        value = new AllocaInst(type, 0, name.c_str(), block);

    }

} // namespace stark