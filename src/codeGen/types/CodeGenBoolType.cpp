#include <llvm/IR/Constants.h>
#include <llvm/IR/IRBuilder.h>

#include "CodeGenPrimaryType.h"
#include "../CodeGenFileContext.h"

namespace stark
{

    CodeGenBoolType::CodeGenBoolType(CodeGenFileContext *context) : CodeGenPrimaryType("bool", context, Type::getInt1Ty(context->getLlvmContext()), "i1") {}

    Value *CodeGenBoolType::convert(Value *value, std::string typeName, FileLocation location)
    {
        if (typeName.compare(this->name) == 0) {
            return value;
        }

        std::string runtimeFunctionName = "none";
        // string
        if (typeName.compare("string") == 0)
        {
            runtimeFunctionName = "stark_runtime_priv_conv_bool_string";
        }
        // int
        else if (typeName.compare("int") == 0)
        {
            runtimeFunctionName = "stark_runtime_priv_conv_bool_int";
        }
        // double
        else if (typeName.compare("double") == 0)
        {
            runtimeFunctionName = "stark_runtime_priv_conv_bool_double";
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
            context->logger.logError(location, formatv("conversion from {0} to {1} is not supported", this->name, typeName));
            return nullptr;
        }
    }

    Value *CodeGenBoolType::create(bool b, FileLocation location)
    {

        return ConstantInt::get(this->getType(), b);
    }

    Value *CodeGenBoolType::createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs, FileLocation location)
    {
        IRBuilder<> Builder(context->getLlvmContext());
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
            return nullptr;
        }

        return Builder.CreateBinOp(instr, lhs, rhs, "binop");
    }

    Value *CodeGenBoolType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs, FileLocation location)
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