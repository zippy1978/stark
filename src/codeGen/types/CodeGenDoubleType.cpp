#include <llvm/IR/Constants.h>
#include <llvm/IR/IRBuilder.h>

#include "CodeGenPrimaryType.h"
#include "../CodeGenContext.h"

namespace stark
{
    CodeGenDoubleType::CodeGenDoubleType(CodeGenContext *context) : CodeGenPrimaryType("double", context, Type::getDoubleTy(context->llvmContext), "double") {}

    Value *CodeGenDoubleType::create(double d, FileLocation location)
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

} // namespace stark