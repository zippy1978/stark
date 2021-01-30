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
    class CodeGenContext;

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
        bool array;
        std::string typeName;
        CodeGenComplexTypeMember(std::string name, std::string typeName, int position, Type *type, bool array) : name(name), typeName(typeName), position(position), type(type), array(array) {}
    };

    /**
     * Represents a complex type.
     * A complex type uses llvm::StructType as type.
     */
    class CodeGenComplexType
    {
    protected:
        std::vector<CodeGenComplexTypeMember *> members;
        CodeGenContext *context;
        StructType *type;
        std::string name;
        bool array;

    public:
        CodeGenComplexType(std::string name, CodeGenContext *context) : name(name), context(context)
        {
            type = NULL;
            array = false;
        }
        CodeGenComplexType(std::string name, CodeGenContext *context, bool array) : name(name), context(context), array(array) { type = NULL; }
        /* Generate declration code of the complex type inside the llvm::LLVMContext */
        void declare();
        /* Returns the complex type llvm::StructType, returns NULL is complex type is not declared yet */
        StructType *getType() { return type; }
        void addMember(std::string name, std::string typeName, Type *type, bool array) { members.push_back(new CodeGenComplexTypeMember(name, typeName, members.size(), type, array)); }
        void addMember(std::string name, std::string typeName, Type *type) { addMember(name, typeName, type, false); }
        CodeGenComplexTypeMember *getMember(std::string name);
        std::string getName() { return name; }
        bool isArray() { return array; }
        virtual Value *create(std::vector<Value *> values, FileLocation location);
        virtual Value *create(std::string string, FileLocation location);
        virtual Value* convert(Value* value, std::string typeName, FileLocation location);
    };

    /**
     * Represents an array complex type.
     */
    class CodeGenArrayComplexType : public CodeGenComplexType
    {
    public:
        CodeGenArrayComplexType(std::string typeName, CodeGenContext *context);
        Value *create(std::vector<Value *> values, FileLocation location);
    };

    /**
     * Represnets a string complex type.
     */
    class CodeGenStringComplexType : public CodeGenComplexType
    {
    public:
        CodeGenStringComplexType(CodeGenContext *context);
        Value* convert(Value* value, std::string typeName, FileLocation location);
        Value *create(std::string string, FileLocation location);
    };

} // namespace stark

#endif