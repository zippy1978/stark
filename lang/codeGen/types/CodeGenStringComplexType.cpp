#include <vector>
#include <llvm/IR/Constant.h>
#include <llvm/IR/IRBuilder.h>

#include "../CodeGenFileContext.h"
#include "CodeGenComplexType.h"

using namespace llvm;
using namespace std;

namespace stark
{

    CodeGenStringComplexType::CodeGenStringComplexType(CodeGenFileContext *context) : CodeGenComplexType("string", context)
    {
        addMember("data", "any", context->getPrimaryType("any")->getType());
        addMember("len", "int", context->getPrimaryType("int")->getType());
    }

    Value *CodeGenStringComplexType::convert(Value *value, std::string typeName)
    {
        if (typeName.compare(this->name) == 0)
        {
            return value;
        }

        if (typeName.compare("any") == 0)
        {
            return new BitCastInst(value, context->getPrimaryType("any")->getType(), "", context->getCurrentBlock());
        }

        std::string runtimeFunctionName = "none";
        // int
        if (typeName.compare("int") == 0)
        {
            runtimeFunctionName = "stark_runtime_priv_conv_string_int";
        }
        // double
        else if (typeName.compare("double") == 0)
        {
            runtimeFunctionName = "stark_runtime_priv_conv_string_double";
        }
        // bool
        else if (typeName.compare("bool") == 0)
        {
            runtimeFunctionName = "stark_runtime_priv_conv_string_bool";
        }

        if (runtimeFunctionName.compare("none") != 0)
        {
            Function *function = context->getLlvmModule()->getFunction(runtimeFunctionName);
            if (function == nullptr)
            {
                context->logger.logError(context->getCurrentLocation(), "cannot find runtime function");
            }
            std::vector<Value *> args;
            args.push_back(value);
            return CallInst::Create(function, makeArrayRef(args), "conv", context->getCurrentBlock());
        }
        else
        {
            context->logger.logError(context->getCurrentLocation(), formatv("conversion from {0} to {1} is not supported", this->name, typeName));
            return nullptr;
        }
    }

    Value *CodeGenStringComplexType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs)
    {
        if (op == ADD)
        {
            // Concat
            Function *function = context->getLlvmModule()->getFunction("stark_runtime_priv_concat_string");
            if (function == nullptr)
            {
                context->logger.logError(context->getCurrentLocation(), "cannot find runtime function");
                return nullptr;
            }
            std::vector<Value *> args;
            args.push_back(lhs);
            args.push_back(rhs);
            return CallInst::Create(function, makeArrayRef(args), "concat", context->getCurrentBlock());
        }
        else
        {
            context->logger.logError(context->getCurrentLocation(), formatv("unsupported binary operation for type {0}", this->name));
            return nullptr;
        }
    }

    void CodeGenStringComplexType::defineConstructor()
    {
        // string constructor is not supported
    }

    Value *CodeGenStringComplexType::createDefaultValue()
    {
        return create("");
    }

    Value *CodeGenStringComplexType::create(std::string string)
    {

        // Create constant vector of the string size
        std::vector<llvm::Constant *> chars(string.size());

        // Set each char of the string in the vector
        Type *charType = Type::getInt8Ty(context->getLlvmContext());
        for (unsigned int i = 0; i < string.size(); i++)
            chars[i] = ConstantInt::get(charType, string[i]);

        IRBuilder<> Builder(context->getLlvmContext());
        Builder.SetInsertPoint(context->getCurrentBlock());

        Type *innerArrayType = ArrayType::get(charType, chars.size());
        Value *innerArrayAllocSize = ConstantExpr::getSizeOf(innerArrayType);
        Value *innerArrayAlloc = context->createMemoryAllocation(innerArrayType, innerArrayAllocSize, context->getCurrentBlock());
        long index = 0;
        for (auto it = chars.begin(); it != chars.end(); it++)
        {
            std::vector<llvm::Value *> indices;
            indices.push_back(ConstantInt::get(context->getLlvmContext(), APInt(32, 0, true)));
            indices.push_back(ConstantInt::get(context->getLlvmContext(), APInt(32, index, true)));
            Value *elementVarValue = Builder.CreateInBoundsGEP(innerArrayAlloc, indices, "dataptr");
            Builder.CreateStore(*it, elementVarValue);
            index++;
        }

        // Create array instance
        Value *arrayAlloc = context->createMemoryAllocation(this->getType(), ConstantExpr::getSizeOf(this->getType()), context->getCurrentBlock());

        // Set len member
        Value *lenMember = Builder.CreateStructGEP(arrayAlloc, 1, "stringleninit");
        Builder.CreateStore(ConstantInt::get(context->getPrimaryType("int")->getType(), chars.size(), true), lenMember);

        // Set elements member with inner array
        Value *elementsMemberPointer = Builder.CreateStructGEP(arrayAlloc, 0, "stringdatainit");
        Builder.CreateStore(new BitCastInst(innerArrayAlloc, charType->getPointerTo(), "", context->getCurrentBlock()), elementsMemberPointer);

        // Return new instance
        return arrayAlloc;
    }

} // namespace stark