#include "CodeGenPrimaryType.h"
#include "../CodeGenContext.h"

namespace stark
{
    CodeGenIntType::CodeGenIntType(CodeGenContext *context) : CodeGenPrimaryType("int", context, Type::getInt64Ty(context->llvmContext), "i64") {}
    Value *CodeGenIntType::cast(Value *value, std::string typeName)
    {
        if (typeName.compare(this->name) == 0) {
            return value;
        } else {
            context->logger.logError(formatv("cast from {0} to {1} is not supported", this->name, typeName));
            return NULL;
        }
    }

    CodeGenDoubleType::CodeGenDoubleType(CodeGenContext *context) : CodeGenPrimaryType("double", context, Type::getDoubleTy(context->llvmContext), "double") {}
    Value *CodeGenDoubleType::cast(Value *value, std::string typeName)
    {
        if (typeName.compare(this->name) == 0) {
            return value;
        } else {
            context->logger.logError(formatv("cast from {0} to {1} is not supported", this->name, typeName));
            return NULL;
        }
    }

    CodeGenBoolType::CodeGenBoolType(CodeGenContext *context) : CodeGenPrimaryType("bool", context, Type::getInt1Ty(context->llvmContext), "i1") {}
    Value *CodeGenBoolType::cast(Value *value, std::string typeName)
    {
        if (typeName.compare(this->name) == 0) {
            return value;
        } else {
            context->logger.logError(formatv("cast from {0} to {1} is not supported", this->name, typeName));
            return NULL;
        }
    }

    CodeGenVoidType::CodeGenVoidType(CodeGenContext *context) : CodeGenPrimaryType("void", context, Type::getVoidTy(context->llvmContext), "void") {}
    Value *CodeGenVoidType::cast(Value *value, std::string typeName)
    {
        if (typeName.compare(this->name) == 0) {
            return value;
        } else {
            context->logger.logError(formatv("cast from {0} to {1} is not supported", this->name, typeName));
            return NULL;
        }
    }

} // namespace stark