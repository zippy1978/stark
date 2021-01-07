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
    /**
     * Represents a complex type member.
     */
    class CodeGenComplexTypeMember
    {
    public:
        std::string name;
        /* Define member position in the structure */
        int position;
        Type *type;
        std::string typeName;
        CodeGenComplexTypeMember(std::string name, std::string typeName, int position, Type *type) : name(name), typeName(typeName), position(position), type(type) {}
    };

    /**
     * Represents a complex type.
     * A complex type uses llvm::StructType as type.
     */
    class CodeGenComplexType
    {
        std::vector<CodeGenComplexTypeMember *> members;
        LLVMContext *llvmContext;
        StructType *type;
        std::string name;

    public:
        CodeGenComplexType(std::string name, LLVMContext *llvmContext) : name(name), llvmContext(llvmContext) { type = NULL; }
        /* Generate declration code of the complex type inside the llvm::LLVMContext */
        void declare();
        /* Returns the complex type llvm::StructType, returns NULL is complex type is not declared yet */
        StructType *getType() { return type; }
        void addMember(std::string name, std::string typeName, Type *type) { members.push_back(new CodeGenComplexTypeMember(name, typeName, members.size(), type)); }
        CodeGenComplexTypeMember *getMember(std::string name);
        std::string getName() { return name; }
    };

} // namespace stark

#endif