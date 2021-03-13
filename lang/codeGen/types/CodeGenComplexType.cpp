#include <vector>
#include <llvm/IR/Constant.h>
#include <llvm/IR/IRBuilder.h>

#include "../CodeGenVisitor.h"
#include "../CodeGenFileContext.h"
#include "CodeGenComplexType.h"

using namespace llvm;
using namespace std;

namespace stark
{
    void CodeGenComplexType::defineConstructor()
    {
        // Mangle name
        std::string functionName = context->getMangler()->mangleStructConstructorName(name, context->getModuleName());

        // Build parameters from members
        vector<Type *> argTypes;
        std::vector<std::unique_ptr<CodeGenComplexTypeMember>> &members = this->members;
        for (auto it = members.begin(); it != members.end(); it++)
        {
            CodeGenComplexTypeMember *m = it->get();
            Type *type = m->type;
            if (m->array)
            {
                type = context->getArrayComplexType(m->typeName)->getType()->getPointerTo();
            }

            argTypes.push_back(type);
        }

        // Create function

        Type *returnType = this->getType()->getPointerTo();

        FunctionType *ftype = FunctionType::get(returnType, makeArrayRef(argTypes), false);
        // TODO : being able to change function visibility by changing ExternalLinkage
        // See https://llvm.org/docs/LangRef.html
        Function *function = Function::Create(ftype, GlobalValue::ExternalLinkage, functionName.c_str(), context->getLlvmModule());

        BasicBlock *bblock = BasicBlock::Create(context->getLlvmContext(), "entry", function, 0);

        context->pushBlock(bblock);

        Function::arg_iterator argsValues = function->arg_begin();
        Value *argumentValue;
        std::vector<Value *> inputArgs;

        for (auto it = members.begin(); it != members.end(); it++)
        {
            CodeGenComplexTypeMember *m = it->get();

            argumentValue = &*argsValues++;
            argumentValue->setName(m->name.c_str());
            Type *type = m->type;
            if (!context->isPrimaryType(m->typeName) && !m->array)
            {
                type = type->getPointerTo();
            }
            // Create local var
            context->declareLocal(new CodeGenVariable(m->name, m->typeName, m->array, type));
            new StoreInst(argumentValue, context->getLocal(m->name)->getValue(), false, context->getCurrentBlock());
            inputArgs.push_back(context->getLocal(m->name)->getValue());
        }

        Value *newInstance = this->create(inputArgs, context->getCurrentLocation());

        // Return new instance
        ReturnInst::Create(context->getLlvmContext(), newInstance, context->getCurrentBlock());

        context->popBlock();
    }

    void CodeGenComplexType::declare()
    {
        // If type already exists
        // declaration was already done
        // exiting
        if (type != nullptr)
        {
            return;
        }

        // Generate member types
        vector<Type *> memberTypes;
        for (auto it = std::begin(members); it != std::end(members); ++it)
        {
            CodeGenComplexTypeMember *m = it->get();
            if (m->array)
            {
                // Array case : must use the matching array complex type
                memberTypes.push_back(context->getArrayComplexType(m->typeName)->getType());
            }
            else
            {
                memberTypes.push_back(m->type);
            }
        }

        // Build and store struct type
        type = StructType::create(context->getLlvmContext(), memberTypes, name, false);

        this->defineConstructor();
    }

    void CodeGenComplexType::addMember(std::string name, std::string typeName, Type *type, bool array)
    {
        // Complex types are pointers !
        if (!context->isPrimaryType(typeName))
        {
            type = type->getPointerTo();
        }
        members.push_back(std::make_unique<CodeGenComplexTypeMember>(name, typeName, members.size(), type, array));
    }

    CodeGenComplexTypeMember *CodeGenComplexType::getMember(std::string name)
    {
        for (auto it = std::begin(members); it != std::end(members); ++it)
        {
            CodeGenComplexTypeMember *m = it->get();
            if (m->name.compare(name) == 0)
            {
                return m;
            }
        }

        return nullptr;
    }

    Value *CodeGenComplexType::create(std::vector<Value *> values, FileLocation location)
    {
        IRBuilder<> Builder(context->getLlvmContext());
        Builder.SetInsertPoint(context->getCurrentBlock());

        // Create new instance
        Value *structAlloc = context->createMemoryAllocation(type, ConstantInt::get(Type::getInt64Ty(context->getLlvmContext()), 1, true), context->getCurrentBlock());

        // Set member values
        int i = 0;
        for (auto it = values.begin(); it != values.end(); it++)
        {
            Value *value = *it;
            Value *memberAddress = Builder.CreateStructGEP(structAlloc, i, "structmemberinit");
            value = Builder.CreateLoad(value);
            Builder.CreateStore(value, memberAddress);
            i++;
        }

        return structAlloc;
    }

    Value *CodeGenComplexType::create(std::string string, FileLocation location)
    {
        return nullptr;
    }

    Value *CodeGenComplexType::convert(Value *value, std::string typeName, FileLocation location)
    {
        if (typeName.compare("any") == 0)
        {
            return new BitCastInst(value, context->getPrimaryType("any")->getType(), "", context->getCurrentBlock());
        }
        else
        {
            context->logger.logError(location, formatv("cannot convert type {0} to type {1}", this->name, typeName));
            return nullptr;
        }
    }

    Value *CodeGenComplexType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs, FileLocation location)
    {
        // Complex types can only be compared to null with == or != operators

        std::string lhsTypeName = context->getTypeName(lhs->getType());
        std::string rhsTypeName = context->getTypeName(rhs->getType());

        if (context->getChecker()->isNull(lhs) || context->getChecker()->isNull(rhs))
        {
            if (context->isPrimaryType(lhsTypeName) || context->isPrimaryType(rhsTypeName))
            {
                IRBuilder<> Builder(context->getLlvmContext());
                Builder.SetInsertPoint(context->getCurrentBlock());

                Value *lhsPointer;
                Value *rhsPointer;
                // Null is lhs
                if (context->isPrimaryType(lhsTypeName))
                {
                    lhsPointer = lhs;
                    rhsPointer = Builder.CreateBitCast(rhs, rhs->getType()->getPointerTo());
                }
                // Null is rhs
                else
                {
                    lhsPointer = Builder.CreateBitCast(lhs, lhs->getType()->getPointerTo());
                    rhsPointer = rhs;
                }

                switch (op)
                {
                case EQ:
                    return Builder.CreateICmpEQ(lhsPointer, rhsPointer, "cmp");
                    break;
                case NE:
                    return Builder.CreateICmpNE(lhsPointer, rhsPointer, "cmp");
                    break;
                case LT:
                case LE:
                case GT:
                case GE:
                default:
                    break;
                }
            }
        }

        context->logger.logError(location, "comparison not supported");
        return nullptr;
    }

} // namespace stark