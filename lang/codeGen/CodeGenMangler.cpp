#include "CodeGenConstants.h"
#include "CodeGenMangler.h"

namespace stark
{

    std::string CodeGenMangler::mangleFunctionName(std::string functionName, std::string moduleName)
    {
        // Never mangle main function !
        if (functionName.compare(MAIN_FUNCTION_NAME) != 0)
        {
            std::string result = STARK_FUNCTION_PREFIX;
            return result.append(moduleName).append(".").append(functionName);
        }
        else
        {
            return functionName;
        }
    }

    std::string CodeGenMangler::mangleAnonymousFunctionName(int id, std::string moduleName, std::string sourceFilename)
    {
        std::string result = STARK_FUNCTION_PREFIX;
        std::replace( sourceFilename.begin(), sourceFilename.end(), '/', '.');
        return result.append(moduleName).append(".").append(sourceFilename).append(".anon").append(std::to_string(id));
    }

    std::string CodeGenMangler::mangleStructConstructorName(std::string structName, std::string moduleName)
    {
        std::string result = STARK_STRUCT_PREFIX;
        return result.append(moduleName).append(".").append(structName).append(".constructor");
    }

    std::string CodeGenMangler::manglePublicRuntimeFunctionName(std::string functionName)
    {
        std::string result = STARK_PUBLIC_RUNTIME_FUNCTION_PREFIX;
        return result.append(functionName);
    }

} // namespace stark