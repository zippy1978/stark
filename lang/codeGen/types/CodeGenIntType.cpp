#include <llvm/IR/Constants.h>
#include <llvm/IR/IRBuilder.h>

#include "CodeGenPrimaryType.h"
#include "../CodeGenFileContext.h"

namespace stark
{
    CodeGenIntType::CodeGenIntType(CodeGenFileContext *context) : CodeGenPrimaryType("int", context, Type::getInt64Ty(context->getLlvmContext()), "i64") {}

    Value *CodeGenIntType::convert(Value *value, std::string typeName)
    {
        if (typeName.compare(this->name) == 0)
        {
            return value;
        }

        std::string runtimeFunctionName = "none";
        // string
        if (typeName.compare("string") == 0)
        {
            runtimeFunctionName = "stark_runtime_priv_conv_int_string";
        }
        // double
        else if (typeName.compare("double") == 0)
        {
            runtimeFunctionName = "stark_runtime_priv_conv_int_double";
        }

        if (runtimeFunctionName.compare("none") != 0)
        {
            Function *function = context->getLlvmModule()->getFunction(runtimeFunctionName);
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

    Value *CodeGenIntType::create(long long i)
    {

        return ConstantInt::get(this->getType(), i);
    }

    Value *CodeGenIntType::createDefaultValue()
    {
        return create(0);
    }

    Value *CodeGenIntType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs)
    {
        IRBuilder<> Builder(context->getLlvmContext());
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

    Value *CodeGenIntType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs)
    {
        IRBuilder<> Builder(context->getLlvmContext());
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