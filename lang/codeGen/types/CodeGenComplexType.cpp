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

        // No constructor is defined if the type has no member
        if (this->members.size() == 0)
        {
            return;
        }

        IRBuilder<> Builder(context->getLlvmContext());
        Builder.SetInsertPoint(context->getCurrentBlock());

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
        // A constructor has an internal visibility, this prevents duplicate issues when compilling a multiple file module
        Function *function = Function::Create(ftype, GlobalValue::InternalLinkage, functionName.c_str(), context->getLlvmModule());

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

            // Array case
            if (m->array)
            {
                type = context->getArrayComplexType(m->typeName)->getType()->getPointerTo();
            }
            // Create local var
            context->declareLocal(new CodeGenVariable(m->name, m->typeName, m->array, type));

            new StoreInst(argumentValue, context->getLocal(m->name)->getValue(), false, context->getCurrentBlock());
            inputArgs.push_back(context->getLocal(m->name)->getValue());
        }

        Value *newInstance = this->create(inputArgs);

        // Return new instance
        ReturnInst::Create(context->getLlvmContext(), newInstance, context->getCurrentBlock());

        context->popBlock();
    }

    void CodeGenComplexType::updateDeclaration(std::vector<CodeGenComplexTypeMember *> newMembers)
    {
        // TODO :
        // Replace all the members
        // Update struct body

        // Clear existing members
        members.clear();

        // Add new members
        int pos = 0;
        vector<Type *> memberTypes;
        for (auto it = newMembers.begin(); it != newMembers.end(); it++)
        {
            CodeGenComplexTypeMember *m = *it;
            members.push_back(std::make_unique<CodeGenComplexTypeMember>(m->name, m->typeName, pos, m->type, m->array));
            pos++;

            if (m->array)
            {
                // Array case : must use the matching array complex type
                memberTypes.push_back(context->getArrayComplexType(m->typeName)->getType()->getPointerTo());
            }
            else
            {
                memberTypes.push_back(m->type);
            }
        }

        type->setBody(memberTypes);

        this->defineConstructor();
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
                memberTypes.push_back(context->getArrayComplexType(m->typeName)->getType()->getPointerTo());
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

    std::vector<CodeGenComplexTypeMember *> CodeGenComplexType::getMembers()
    {
        std::vector<CodeGenComplexTypeMember *> result;

        for (auto it = members.begin(); it != members.end(); it++)
        {
            CodeGenComplexTypeMember *m = it->get();
            result.push_back(m);
        }

        return result;
    }

    Value *CodeGenComplexType::createDefaultValue()
    {
        // Default value for a complex type is null
        return ConstantPointerNull::getNullValue(type->getPointerTo());
    }

    Value *CodeGenComplexType::create(std::vector<Value *> values)
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

    Value *CodeGenComplexType::create(std::string string)
    {
        return nullptr;
    }

    Value *CodeGenComplexType::convert(Value *value, std::string typeName)
    {
        if (typeName.compare("any") == 0)
        {
            return new BitCastInst(value, context->getPrimaryType("any")->getType(), "", context->getCurrentBlock());
        }
        else
        {
            context->logger.logError(context->getCurrentLocation(), formatv("cannot convert type {0} to type {1}", this->name, typeName));
            return nullptr;
        }
    }

    Value *CodeGenComplexType::createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs)
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

                // Convert pointer address to int for comparison
                Value *lhsPointerInt = Builder.CreatePtrToInt(lhs, context->getPrimaryType("int")->getType());
                Value *rhsPointerInt = Builder.CreatePtrToInt(rhs, context->getPrimaryType("int")->getType());

                switch (op)
                {
                case EQ:
                    return Builder.CreateICmpEQ(lhsPointerInt, rhsPointerInt, "cmp");
                    break;
                case NE:
                    return Builder.CreateICmpNE(lhsPointerInt, rhsPointerInt, "cmp");
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

        context->logger.logError(context->getCurrentLocation(), "comparison not supported");
        return nullptr;
    }

} // namespace stark