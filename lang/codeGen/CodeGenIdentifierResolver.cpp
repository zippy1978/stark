#include "CodeGenFileContext.h"
#include "CodeGenIdentifierResolver.h"

namespace stark
{

    Function *CodeGenIdentifierResolver::resolveFunction(ASTIdentifier *id)
    {
        std::string moduleName = context->getModuleName();
        int memberCount = id->countNestedMembers();
        Function *function = nullptr;

        // If id matched a type : look for its constructor
        if (context->getComplexType(id->getFullName()) != nullptr)
        {
            // If identifier has a member : then it is module.function
            if (memberCount == 1)
            {
                moduleName = id->getName();
                function = context->getLlvmModule()->getFunction(context->getMangler()->mangleStructConstructorName(id->getMember()->getName(), moduleName).c_str());
            }
            else
            {
                function = context->getLlvmModule()->getFunction(context->getMangler()->mangleStructConstructorName(id->getName(), moduleName).c_str());
            }
        }
        else
        {
            // If identifier has a member : then it is module.function
            if (memberCount == 1)
            {
                moduleName = id->getName();
                function = context->getLlvmModule()->getFunction(context->getMangler()->mangleFunctionName(id->getMember()->getName(), moduleName).c_str());
            }
            else
            {
                // Local module stark function
                function = context->getLlvmModule()->getFunction(context->getMangler()->mangleFunctionName(id->getName(), moduleName).c_str());

                // Try to find a runtime function
                if (function == nullptr)
                {
                    function = context->getLlvmModule()->getFunction(context->getMangler()->manglePublicRuntimeFunctionName(id->getName()).c_str());
                }

                // Finally : look for an unmangled function
                if (function == nullptr)
                {
                    function = context->getLlvmModule()->getFunction(id->getName().c_str());
                }
            }
        }

        return function;
    }

} // namespace stark