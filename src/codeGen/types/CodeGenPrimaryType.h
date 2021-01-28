#ifndef CODEGEN_TYPES_CODEGENTYPE_H
#define CODEGEN_TYPES_CODEGENTYPE_H

#include <iostream>
#include <map>
#include <llvm/IR/Type.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/LLVMContext.h>

#include "../../ast/AST.h"

using namespace llvm;

namespace stark
{
    class CodeGenContext;

    /**
     * Represents an abstract primary type.
     */
    class CodeGenPrimaryType
    {
    protected:
        std::string name;
        std::string llvmTypeName;
        Type *type;
        CodeGenContext *context;

    public:
        CodeGenPrimaryType(std::string name, CodeGenContext *context, Type *type, std::string llvmTypeName) : name(name), context(context), type(type), llvmTypeName(llvmTypeName)  {}
        Type *getType() { return type; }
        std::string getName() { return name; }
        std::string getLLvmTypeName() { return llvmTypeName; }
        /* Cast a value of the current type to a given type */
        Value* cast(Value* value, std::string typeName);
        virtual Value* createConstant(long long i);
        virtual Value* createConstant(double d);
        virtual Value* createConstant(bool b);
        virtual Value* createBinaryOperation(Value * lhs, ASTBinaryOperator op, Value *rhs);
    };

    /**
     * Represents a int type
     */
    class CodeGenIntType : public CodeGenPrimaryType
    {
    public:
        CodeGenIntType(CodeGenContext *context);
        Value* createConstant(long long i);
        Value* createBinaryOperation(Value * lhs, ASTBinaryOperator op, Value *rhs);
    };

    /**
     * Represents a double type
     */
    class CodeGenDoubleType : public CodeGenPrimaryType
    {
    public:
        CodeGenDoubleType(CodeGenContext *context);
        Value* createConstant(double d);
        Value* createBinaryOperation(Value * lhs, ASTBinaryOperator op, Value *rhs);
    };

    /**
     * Represents a bool type
     */
    class CodeGenBoolType : public CodeGenPrimaryType
    {
    public:
        CodeGenBoolType(CodeGenContext *context);
        Value* createConstant(bool b);
        Value* createBinaryOperation(Value * lhs, ASTBinaryOperator op, Value *rhs);
    };

    /**
     * Represents a void type
     */
    class CodeGenVoidType : public CodeGenPrimaryType
    {
    public:
        CodeGenVoidType(CodeGenContext *context);
    };

    /**
     * Represents a pointer type
     */
    class CodeGenAnyType : public CodeGenPrimaryType
    {
    public:
        CodeGenAnyType(CodeGenContext *context);
    };

} // namespace stark

#endif