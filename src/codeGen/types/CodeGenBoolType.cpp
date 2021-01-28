#include <llvm/IR/Constants.h>
#include <llvm/IR/IRBuilder.h>

#include "CodeGenPrimaryType.h"
#include "../CodeGenContext.h"

namespace stark
{

    CodeGenBoolType::CodeGenBoolType(CodeGenContext *context) : CodeGenPrimaryType("bool", context, Type::getInt1Ty(context->llvmContext), "i1") {}

    Value *CodeGenBoolType::create(bool b, FileLocation location)
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