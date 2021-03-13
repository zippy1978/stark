#include <llvm/IR/Constants.h>
#include <llvm/IR/IRBuilder.h>

#include "CodeGenPrimaryType.h"
#include "../CodeGenFileContext.h"

namespace stark
{
    CodeGenDoubleType::CodeGenDoubleType(CodeGenFileContext *context) : CodeGenPrimaryType("double", context, Type::getDoubleTy(context->getLlvmContext()), "double") {}

    Value *CodeGenDoubleType::convert(Value *value, std::string typeName)
    {
        if (typeName.compare(this->name) == 0) {
            return value;
        }

        // string
        if (typeName.compare("string") == 0)
        {
            Function *function = context->getLlvmModule()->getFunction("stark_runtime_priv_conv_double_string");
            if (function == nullptr)
            {
                context->logger.logError("cannot find runtime function");
            }
            std::vector<Value *> args;
            args.push_back(value);
            return CallInst::Create(function, makeArrayRef(args), "conv", context->getCurrentBlock());
        }
        else
        {
            context->logger.logError(context->getCurrentLocation(), formatv("conversion from {0} to {1} is not supported", this->name, typeName));
            return nullptr;
        }
    }

    Value *CodeGenDoubleType::create(double d)
    {

        return ConstantFP::get(this->getType(), d);
    }

    Value *CodeGenDoubleType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs)
    {
        IRBuilder<> Builder(context->getLlvmContext());
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

    Value *CodeGenDoubleType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs)
    {
        IRBuilder<> Builder(context->getLlvmContext());
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