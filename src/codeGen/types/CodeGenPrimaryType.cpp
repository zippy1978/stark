#include <llvm/IR/Constants.h>
#include <llvm/IR/IRBuilder.h>

#include "CodeGenPrimaryType.h"
#include "../CodeGenContext.h"

namespace stark
{
    CodeGenIntType::CodeGenIntType(CodeGenContext *context) : CodeGenPrimaryType("int", context, Type::getInt64Ty(context->llvmContext), "i64") {}
    CodeGenDoubleType::CodeGenDoubleType(CodeGenContext *context) : CodeGenPrimaryType("double", context, Type::getDoubleTy(context->llvmContext), "double") {}
    CodeGenBoolType::CodeGenBoolType(CodeGenContext *context) : CodeGenPrimaryType("bool", context, Type::getInt1Ty(context->llvmContext), "i1") {}
    CodeGenVoidType::CodeGenVoidType(CodeGenContext *context) : CodeGenPrimaryType("void", context, Type::getVoidTy(context->llvmContext), "void") {}
    CodeGenAnyType::CodeGenAnyType(CodeGenContext *context) : CodeGenPrimaryType("any", context, Type::getInt8PtrTy(context->llvmContext), "i8*") {}

    Value *CodeGenPrimaryType::cast(Value *value, std::string typeName)
    {
        if (typeName.compare(this->name) == 0)
        {
            return value;
        }
        else
        {
            context->logger.logError(formatv("cast from {0} to {1} is not supported", this->name, typeName));
            return NULL;
        }
    }

    Value *CodeGenPrimaryType::createConstant(long long i)
    {
        context->logger.logError(formatv("cannot create constant of type {0} with value {1}", this->name, i));
        return NULL;
    }

    Value *CodeGenPrimaryType::createConstant(double d)
    {
        context->logger.logError(formatv("cannot create constant of type {0} with value {1}", this->name, d));
        return NULL;
    }
    Value *CodeGenPrimaryType::createConstant(bool b)
    {
        context->logger.logError(formatv("cannot create constant of type {0} with value {1}", this->name, b));
        return NULL;
    }

    Value *CodeGenPrimaryType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs)
    {
        context->logger.logError(formatv("unsupported binary operation for type {0}", this->name));
        return NULL;
    }

    Value *CodeGenIntType::createConstant(long long i)
    {

        return ConstantInt::get(this->getType(), i);
    }

    Value *CodeGenIntType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs)
    {
        IRBuilder<> Builder(context->llvmContext);
        Builder.SetInsertPoint(context->getCurrentBlock());

        Instruction::BinaryOps instr;
        switch (op)
        {
        case ADD:
            instr = Instruction::Add;
            break;
        case SUB:
            instr = Instruction::Sub;
            break;
        case MUL:
            instr = Instruction::Mul;
            break;
        case DIV:
            instr = Instruction::SDiv;
            break;
        case OR:
            instr = Instruction::Or;
            break;
        case AND:
            instr = Instruction::And;
            break;
        }

        return Builder.CreateBinOp(instr, lhs, rhs, "binop");
    }

    Value *CodeGenDoubleType::createConstant(double d)
    {

        return ConstantFP::get(this->getType(), d);
    }

    Value *CodeGenDoubleType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs)
    {
        IRBuilder<> Builder(context->llvmContext);
        Builder.SetInsertPoint(context->getCurrentBlock());

        Instruction::BinaryOps instr;
        switch (op)
        {
        case ADD:
            instr = Instruction::FAdd;
            break;
        case SUB:
            instr = Instruction::FSub;
            break;
        case MUL:
            instr = Instruction::FMul;
            break;
        case DIV:
            instr = Instruction::FDiv;
            break;
        case OR:
            instr = Instruction::Or;
            break;
        case AND:
            instr = Instruction::And;
            break;
        }

        return Builder.CreateBinOp(instr, lhs, rhs, "binop");
    }

    Value *CodeGenBoolType::createConstant(bool b)
    {

        return ConstantInt::get(this->getType(), b);
    }

    Value *CodeGenBoolType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs)
    {
        IRBuilder<> Builder(context->llvmContext);
        Builder.SetInsertPoint(context->getCurrentBlock());

        Instruction::BinaryOps instr;
        switch (op)
        {
        case OR:
            instr = Instruction::Or;
            break;
        case AND:
            instr = Instruction::And;
            break;
        default:
            context->logger.logError(formatv("unsupported binary operation for type {0}", this->name));
            return NULL;
        }

        return Builder.CreateBinOp(instr, lhs, rhs, "binop");
    }

} // namespace stark