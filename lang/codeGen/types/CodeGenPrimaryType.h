#ifndef CODEGEN_TYPES_CODEGENPRIMARYTYPE_H
#define CODEGEN_TYPES_CODEGENPRIMARYTYPE_H

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
    class CodeGenFileContext;

    /**
     * Represents an abstract primary type.
     */
    class CodeGenPrimaryType
    {
    protected:
        std::string name;
        std::string llvmTypeName;
        Type *type;
        CodeGenFileContext *context;

    public:
        CodeGenPrimaryType(std::string name, CodeGenFileContext *context, Type *type, std::string llvmTypeName) : name(name), context(context), type(type), llvmTypeName(llvmTypeName) {}
        Type *getType() { return type; }
        std::string getName() { return name; }
        std::string getLLvmTypeName() { return llvmTypeName; }
        /* Convert a value of the current type to a given type */
        virtual Value *convert(Value *value, std::string typeName);
        virtual Value *create(long long i);
        virtual Value *create(double d);
        virtual Value *create(bool b);
        virtual Value *createDefaultValue();
        virtual Value *createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs);
        virtual Value *createModifierOperation(Value *lhs, ASTModifierOperator op, Value *rhs);
        virtual Value *createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs);
    };

    /**
     * Represents a int type
     */
    class CodeGenIntType : public CodeGenPrimaryType
    {
    public:
        CodeGenIntType(CodeGenFileContext *context);
        Value *convert(Value *value, std::string typeName);
        Value *create(long long i);
        Value *createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs);
        Value *createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs);
        Value *createDefaultValue();
    };

    /**
     * Represents a double type
     */
    class CodeGenDoubleType : public CodeGenPrimaryType
    {
    public:
        CodeGenDoubleType(CodeGenFileContext *context);
        Value *convert(Value *value, std::string typeName);
        Value *create(double d);
        Value *createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs);
        Value *createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs);
        Value *createDefaultValue();
    };

    /**
     * Represents a bool type
     */
    class CodeGenBoolType : public CodeGenPrimaryType
    {
    public:
        CodeGenBoolType(CodeGenFileContext *context);
        Value *convert(Value *value, std::string typeName);
        Value *create(bool b);
        Value *createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs);
        Value *createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs);
        Value *createDefaultValue();
    };

    /**
     * Represents a void type
     */
    class CodeGenVoidType : public CodeGenPrimaryType
    {
    public:
        CodeGenVoidType(CodeGenFileContext *context);
    };

    /**
     * Represents a pointer type
     */
    class CodeGenAnyType : public CodeGenPrimaryType
    {
    public:
        CodeGenAnyType(CodeGenFileContext *context);
        Value *createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs);
        Value *createDefaultValue();
    };

} // namespace stark

#endif