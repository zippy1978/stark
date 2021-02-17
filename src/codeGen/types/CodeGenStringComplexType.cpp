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
        addMember("data", "-", Type::getInt8PtrTy(context->llvmContext));
        addMember("len", "int", context->getPrimaryType("int")->getType());
    }

    Value *CodeGenStringComplexType::convert(Value *value, std::string typeName, FileLocation location)
    {
        if (typeName.compare(this->name) == 0) {
            return value;
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
                context->logger.logError("cannot find runtime function");
            }
            std::vector<Value *> args;
            args.push_back(value);
            return CallInst::Create(function, makeArrayRef(args), "conv", context->getCurrentBlock());
        }
        else
        {
            context->logger.logError(location, formatv("conversion from {0} to {1} is not supported", this->name, typeName));
            return nullptr;
        }
    }

    Value *CodeGenStringComplexType::create(std::string string, FileLocation location)
    {

        // Create constant vector of the string size
        std::vector<llvm::Constant *> chars(string.size());

        // Set each char of the string in the vector
        for (unsigned int i = 0; i < string.size(); i++)
            chars[i] = ConstantInt::get(Type::getInt8Ty(context->llvmContext), string[i]);

        IRBuilder<> Builder(context->llvmContext);
        Builder.SetInsertPoint(context->getCurrentBlock());

        Type *charType = Type::getInt8Ty(context->llvmContext);

        Value *innerArrayAlloc = context->createMemoryAllocation(ArrayType::get(charType, chars.size()), ConstantInt::get(Type::getInt64Ty(context->llvmContext), chars.size(), true), context->getCurrentBlock());
        long index = 0;
        for (auto it = chars.begin(); it != chars.end(); it++)
        {
            std::vector<llvm::Value *> indices;
            indices.push_back(ConstantInt::get(context->llvmContext, APInt(32, 0, true)));
            indices.push_back(ConstantInt::get(context->llvmContext, APInt(32, index, true)));
            Value *elementVarValue = Builder.CreateInBoundsGEP(innerArrayAlloc, indices, "elementptr");
            Builder.CreateStore(*it, elementVarValue);
            index++;
        }

        // Create array instance
        Value *arrayAlloc = context->createMemoryAllocation(context->getComplexType("string")->getType(), ConstantInt::get(Type::getInt64Ty(context->llvmContext), 1, true), context->getCurrentBlock());

        // Set len member
        Value *lenMember = Builder.CreateStructGEP(arrayAlloc, 1, "arrayleninit");
        Builder.CreateStore(ConstantInt::get(Type::getInt64Ty(context->llvmContext), chars.size(), true), lenMember);

        // Set elements member with inner array
        Value *elementsMemberPointer = Builder.CreateStructGEP(arrayAlloc, 0, "arrayeleminit");
        Builder.CreateStore(new BitCastInst(innerArrayAlloc, charType->getPointerTo(), "", context->getCurrentBlock()), elementsMemberPointer);

        // Return new instance
        return Builder.CreateLoad(arrayAlloc->getType()->getPointerElementType(), arrayAlloc, "load");
    }

} // namespace stark