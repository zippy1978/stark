#ifndef CODEGEN_CODEGENMANGLER_H
#define CODEGEN_CODEGENMANGLER_H

#include <string>

namespace stark
{
    /**
     * Code mangler.
     */
    class CodeGenMangler
    {
        

    public:
        std::string mangleTypeName(std::string typeName, std::string moduleName);
        std::string mangleFunctionName(std::string functionName, std::string moduleName);
        std::string manglePublicRuntimeFunctionName(std::string functionName);
    };

} // namespace stark

#endif