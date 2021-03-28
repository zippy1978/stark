#include <vector>
#include <llvm/IR/Constant.h>
#include <llvm/IR/IRBuilder.h>

#include "../CodeGenFileContext.h"
#include "CodeGenComplexType.h"

using namespace llvm;
using namespace std;

namespace stark
{

    CodeGenArrayComplexType::CodeGenArrayComplexType(std::string typeName, CodeGenFileContext *context) : CodeGenComplexType(formatv("array.{0}", typeName), context, true)
    {
        Type *t = context->getType(typeName);

        addMember("elements", typeName, t->getPointerTo());
        addMember("len", "int", context->getPrimaryType("int")->getType());
    }

    void CodeGenArrayComplexType::defineConstructor()
    {
        // Array constructor is not supported
    }

    Value *CodeGenArrayComplexType::createDefaultValue()
    {
        std::vector<Value *> values;
        return create(values);
    }

    Value *CodeGenArrayComplexType::create(std::vector<Value *> values)
    {

        // Get array element type
        Type *elementType = this->members[0]->type->getPointerElementType();
        
        IRBuilder<> Builder(context->getLlvmContext());
        Builder.SetInsertPoint(context->getCurrentBlock());

        // Alloc inner array
        // If element type is a complex type : it is a pointer
        Type *innerArrayType = ArrayType::get(elementType, values.size());
        Value* innerArrayAllocSize = ConstantExpr::getSizeOf(innerArrayType);
        Value *innerArrayAlloc = context->createMemoryAllocation(innerArrayType, innerArrayAllocSize, context->getCurrentBlock());
        // Initialize inner array with elements
        // TODO : there is probably a way to write the whole content in a single instruction !!!
        long index = 0;
        for (auto it = values.begin(); it != values.end(); it++)
        {
            std::vector<llvm::Value *> indices;
            indices.push_back(ConstantInt::get(context->getLlvmContext(), APInt(32, 0, true)));
            indices.push_back(ConstantInt::get(context->getLlvmContext(), APInt(32, index, true)));
            Value *elementVarValue = Builder.CreateInBoundsGEP(innerArrayAlloc, indices, "elementptr");
            Builder.CreateStore(*it, elementVarValue);
            index++;
        }

        // Create array 
        Type *arrayType = context->getArrayComplexType(context->getTypeName(elementType))->getType();
        Constant* arrayAllocSize = ConstantExpr::getSizeOf(arrayType);
        Value *arrayAlloc = context->createMemoryAllocation(arrayType, arrayAllocSize, context->getCurrentBlock());

        // Set len member
        Value *lenMember = Builder.CreateStructGEP(arrayAlloc, 1, "arrayleninit");
        Builder.CreateStore(ConstantInt::get(context->getPrimaryType("int")->getType(), values.size(), true), lenMember);

        // Set elements member with inner array
        Value *elementsMemberPointer = Builder.CreateStructGEP(arrayAlloc, 0, "arrayeleminit");
        Builder.CreateStore(new BitCastInst(innerArrayAlloc, elementType->getPointerTo(), "", context->getCurrentBlock()), elementsMemberPointer);

        // Return new instance
        return arrayAlloc;
    }

} // namespace stark