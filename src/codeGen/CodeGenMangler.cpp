#include "CodeGenMangler.h"

#define STARK_FUNCTION_PREFIX "stark.functions."
#define STARK_PUBLIC_RUNTIME_FUNCTION_PREFIX "stark_runtime_pub_"

namespace stark
{

    std::string CodeGenMangler::mangleFunctionName(std::string functionName, std::string moduleName)
    {
        // Never mangle main function !
        if (functionName.compare("main") != 0)
        {
            std::string result = STARK_FUNCTION_PREFIX;
            return result.append(moduleName).append(".").append(functionName);
        }
        else
        {
            return functionName;
        }
    }

    std::string CodeGenMangler::manglePublicRuntimeFunctionName(std::string functionName)
    {
        std::string result = STARK_PUBLIC_RUNTIME_FUNCTION_PREFIX;
        return result.append(functionName);
    }

} // namespace stark