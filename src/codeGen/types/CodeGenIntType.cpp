#include <llvm/IR/Constants.h>
#include <llvm/IR/IRBuilder.h>

#include "CodeGenPrimaryType.h"
#include "../CodeGenContext.h"

namespace stark
{
    CodeGenIntType::CodeGenIntType(CodeGenContext *context) : CodeGenPrimaryType("int", context, Type::getInt64Ty(context->llvmContext), "i64") {}

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

} // namespace stark