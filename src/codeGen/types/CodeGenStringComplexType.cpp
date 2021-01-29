#include <vector>
#include <llvm/IR/Constant.h>
#include <llvm/IR/IRBuilder.h>

#include "../CodeGenContext.h"
#include "CodeGenComplexType.h"

using namespace llvm;
using namespace std;

namespace stark
{
    CodeGenStringComplexType::CodeGenStringComplexType(CodeGenContext *context) : CodeGenComplexType("string", context)
    {
        addMember("data", "-", Type::getInt8PtrTy(context->llvmContext));
        addMember("len", "int", context->getPrimaryType("int")->getType());
    }

    Value *CodeGenStringComplexType::create(std::string string, FileLocation location)
    {

        // Create constant vector of the string size
        std::vector<llvm::Constant *> chars(string.size() );

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