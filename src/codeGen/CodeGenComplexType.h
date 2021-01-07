#ifndef CODEGEN_CODEGENCOMPLEXTYPE_H
#define CODEGEN_CODEGENCOMPLEXTYPE_H

#include <iostream>
#include <map>
#include <llvm/IR/Type.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/LLVMContext.h>

using namespace llvm;

namespace stark
{
    class CodeGenComplexTypeMember
    {
    public:
        std::string name;
        int position;
        Type *type;
        CodeGenComplexTypeMember(std::string name, int position, Type *type) : name(name), position(position), type(type) {}
    };

    class CodeGenComplexType
    {
        std::vector<CodeGenComplexTypeMember *> members;
        LLVMContext *llvmContext;
        StructType *type;

    public:
        std::string name;
        CodeGenComplexType(std::string name, LLVMContext *llvmContext) : name(name), llvmContext(llvmContext) {}
        void declare();
        StructType *getType() { return type; }
        void addMember(std::string name, Type *type) { members.push_back(new CodeGenComplexTypeMember(name, members.size(), type)); }
        CodeGenComplexTypeMember *getMember(std::string name);
    };

} // namespace stark

#endif