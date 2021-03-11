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
    class CodeGenFileContext;

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
        std::vector<std::unique_ptr<CodeGenComplexTypeMember>> members;
        CodeGenFileContext *context;
        StructType *type;
        std::string name;
        bool array;

    private:
        /** Create function definition for the type construction */
        virtual void defineConstructor();

    public:
        CodeGenComplexType(std::string name, CodeGenFileContext *context) : name(name), context(context)
        {
            type = nullptr;
            array = false;
        }
        CodeGenComplexType(std::string name, CodeGenFileContext *context, bool array) : name(name), context(context), array(array) { type = nullptr; }
        /** Generates declaration code of the complex type inside the llvm::LLVMContext */
        void declare();

        /** Returns the complex type llvm::StructType, returns nullptr is complex type is not declared yet */
        StructType *getType() { return type; }
        void addMember(std::string name, std::string typeName, Type *type, bool array) { members.push_back(std::make_unique<CodeGenComplexTypeMember>(name, typeName, members.size(), type, array)); }
        void addMember(std::string name, std::string typeName, Type *type) { addMember(name, typeName, type, false); }
        CodeGenComplexTypeMember *getMember(std::string name);
        std::string getName() { return name; }
        bool isArray() { return array; }
        virtual Value *create(std::vector<Value *> values, FileLocation location);
        virtual Value *create(std::string string, FileLocation location);
        virtual Value *convert(Value *value, std::string typeName, FileLocation location);
        virtual Value *createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs, FileLocation location);
    };

    /**
     * Represents an array complex type.
     */
    class CodeGenArrayComplexType : public CodeGenComplexType
    {
    public:
        CodeGenArrayComplexType(std::string typeName, CodeGenFileContext *context);
        Value *create(std::vector<Value *> values, FileLocation location);
        void defineConstructor();
    };

    /**
     * Represnets a string complex type.
     */
    class CodeGenStringComplexType : public CodeGenComplexType
    {
    public:
        CodeGenStringComplexType(CodeGenFileContext *context);
        Value *convert(Value *value, std::string typeName, FileLocation location);
        Value *create(std::string string, FileLocation location);
        void defineConstructor();
    };

} // namespace stark

#endif