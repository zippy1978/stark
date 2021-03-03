#include "CodeGenFileContext.h"
#include "CodeGenConstants.h"

#include "CodeGenChecker.h"

namespace stark
{
    void CodeGenChecker::checkNoMemberIdentifier(ASTIdentifier *variableId)
    {
        if (variableId->countNestedMembers() > 0)
        {
            context->logger.logError(variableId->location, formatv("invalid identifier {0}", variableId->getFullName()));
        }
    }

    void CodeGenChecker::checkTypeIdentifier(ASTIdentifier *typeId)
    {
        // A type id can have a module prefix module.type
        if (typeId->countNestedMembers() > 1 && typeId->getIndex() != nullptr)
        {
            context->logger.logError(typeId->location, formatv("invalid type identifier {0}", typeId->getFullName()));
        }
    }

    void CodeGenChecker::checkAllowedVariableDeclaration(ASTIdentifier *variableId)
    {

        if (context->getLocal(variableId->getName()) == nullptr)
        {
            context->logger.logError(variableId->location, formatv("undeclared variable {0}", variableId->getFullName()));
        }
    }

    void CodeGenChecker::checkAvailableLocalVariable(ASTIdentifier *variableId)
    {
        checkNoMemberIdentifier(variableId);

        if (context->getLocal(variableId->getName()) != nullptr)
        {
            context->logger.logError(variableId->location, formatv("variable {0} already declared", variableId->getFullName()));
        }
    }

    void CodeGenChecker::checkVariableAssignment(ASTIdentifier *variableId, Value *variable, Value *value)
    {
        std::string valueTypeName = context->getTypeName(value->getType());
        std::string varTypeName = context->getTypeName(variable->getType()->getPointerElementType());
        if (varTypeName.compare(valueTypeName) != 0)
        {
            context->logger.logError(variableId->location, formatv("cannot assign value of type {0} to variable {1} of type {2}", valueTypeName, variableId->getFullName(), varTypeName));
        }
    }

    void CodeGenChecker::checkAllowedTypeDeclaration(ASTIdentifier *typeId)
    {
        checkTypeIdentifier(typeId);

        if (context->getPrimaryType(typeId->getName()) != nullptr || context->getComplexType(typeId->getFullName()) != nullptr)
        {
            context->logger.logError(typeId->location, formatv("type {0} already declared", typeId->getFullName()));
        }
    }

    void CodeGenChecker::checkAllowedFunctionDeclaration(ASTIdentifier *functionId)
    {
        // Mangle name
        std::string functionName = context->getMangler()->mangleFunctionName(functionId->getName(), context->getModuleName());

        if (context->getLlvmModule()->getFunction(functionName.c_str()) != nullptr)
        {
            context->logger.logError(functionId->location, formatv("function {0} already declared", functionId->getName()));
        }
    }

    void CodeGenChecker::checkAllowedFunctionCall(ASTIdentifier *functionId, Function *function, std::vector<Value *> args)
    {

        if (functionId->getName().compare(MAIN_FUNCTION_NAME) == 0)
        {
            context->logger.logError(functionId->location, "main function cannot be called");
        }

        if (functionId->getName().rfind(RUNTIME_PRIVATE_FUNCTION_PREFIX, 0) == 0)
        {
            context->logger.logError(functionId->location, "calling private runtime functions is not allowed");
        }

        // Check args count
        if (function->arg_size() != args.size())
        {
            context->logger.logError(functionId->location, formatv("function {0} is expecting {1} argument(s), not {2}", functionId->getName(), function->arg_size(), args.size()));
        }

        // Check args
        int i = 0;
        for (auto it = args.begin(); it != args.end(); it++)
        {
            Value *argValue = *it;
            std::string argTypeName = context->getTypeName(function->getArg(i)->getType());
            std::string valueTypeName = context->getTypeName(argValue->getType());
            if (argTypeName.compare(valueTypeName) != 0)
            {
                context->logger.logError(functionId->location, formatv("function {0} is expecting a {1} type for argument number {2}, instead of {3} type", functionId->getName(), argTypeName, i, valueTypeName));
            }
            i++;
        }
    }

    void CodeGenChecker::checkAllowedModuleDeclaration(ASTIdentifier *moduleId)
    {
        if (moduleId->countNestedMembers() > 0)
        {
            context->logger.logError(moduleId->location, formatv("invalid module identifier {0}", moduleId->getFullName()));
        }
    }

} // namespace stark