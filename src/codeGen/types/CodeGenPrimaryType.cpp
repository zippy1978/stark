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

    Value *CodeGenPrimaryType::convert(Value *value, std::string typeName)
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

    Value *CodeGenPrimaryType::createConstant(long long i, FileLocation location)
    {
        context->logger.logError(location, formatv("cannot create constant of type {0} with value {1}", this->name, i));
        return NULL;
    }

    Value *CodeGenPrimaryType::createConstant(double d, FileLocation location)
    {
        context->logger.logError(location, formatv("cannot create constant of type {0} with value {1}", this->name, d));
        return NULL;
    }
    Value *CodeGenPrimaryType::createConstant(bool b, FileLocation location)
    {
        context->logger.logError(location, formatv("cannot create constant of type {0} with value {1}", this->name, b));
        return NULL;
    }

    Value *CodeGenPrimaryType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs, FileLocation location)
    {
        context->logger.logError(location, formatv("unsupported binary operation for type {0}", this->name));
        return NULL;
    }

    Value *CodeGenPrimaryType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs, FileLocation location)
    {
        context->logger.logError(location, formatv("unsupported comparison for type {0}", this->name));
        return NULL;
    }

    Value *CodeGenIntType::createConstant(long long i, FileLocation location)
    {

        return ConstantInt::get(this->getType(), i);
    }

    Value *CodeGenIntType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs, FileLocation location)
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

    Value *CodeGenIntType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs, FileLocation location)
    {
        IRBuilder<> Builder(context->llvmContext);
        Builder.SetInsertPoint(context->getCurrentBlock());

        Instruction::BinaryOps instr;
        switch (op)
        {
        case EQ:
            return Builder.CreateICmpEQ(lhs, rhs, "cmp");
            break;
        case NE:
            return Builder.CreateICmpNE(lhs, rhs, "cmp");
            break;
        case LT:
            return Builder.CreateICmpSLT(lhs, rhs, "cmp");
            break;
        case LE:
            return Builder.CreateICmpSLE(lhs, rhs, "cmp");
            break;
        case GT:
            return Builder.CreateICmpSGT(lhs, rhs, "cmp");
            break;
        case GE:
            return Builder.CreateICmpSGE(lhs, rhs, "cmp");
            break;
        }
    }

    Value *CodeGenDoubleType::createConstant(double d, FileLocation location)
    {

        return ConstantFP::get(this->getType(), d);
    }

    Value *CodeGenDoubleType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs, FileLocation location)
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

    Value *CodeGenDoubleType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs, FileLocation location)
    {
        IRBuilder<> Builder(context->llvmContext);
        Builder.SetInsertPoint(context->getCurrentBlock());

        Instruction::BinaryOps instr;
        switch (op)
        {
        case EQ:
            return Builder.CreateFCmpOEQ(lhs, rhs, "cmp");
            break;
        case NE:
            return Builder.CreateFCmpONE(lhs, rhs, "cmp");
            break;
        case LT:
            return Builder.CreateFCmpOLT(lhs, rhs, "cmp");
            break;
        case LE:
            return Builder.CreateFCmpOLE(lhs, rhs, "cmp");
            break;
        case GT:
            return Builder.CreateFCmpOGT(lhs, rhs, "cmp");
            break;
        case GE:
            return Builder.CreateFCmpOGE(lhs, rhs, "cmp");
            break;
        }
    }

    Value *CodeGenBoolType::createConstant(bool b, FileLocation location)
    {

        return ConstantInt::get(this->getType(), b);
    }

    Value *CodeGenBoolType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs, FileLocation location)
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

    Value *CodeGenBoolType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs, FileLocation location)
    {
        IRBuilder<> Builder(context->llvmContext);
        Builder.SetInsertPoint(context->getCurrentBlock());

        Instruction::BinaryOps instr;
        switch (op)
        {
        case EQ:
            return Builder.CreateICmpEQ(lhs, rhs, "cmp");
            break;
        case NE:
            return Builder.CreateICmpNE(lhs, rhs, "cmp");
            break;
        case LT:
            return Builder.CreateICmpSLT(lhs, rhs, "cmp");
            break;
        case LE:
            return Builder.CreateICmpSLE(lhs, rhs, "cmp");
            break;
        case GT:
            return Builder.CreateICmpSGT(lhs, rhs, "cmp");
            break;
        case GE:
            return Builder.CreateICmpSGE(lhs, rhs, "cmp");
            break;
        }
    }

} // namespace stark