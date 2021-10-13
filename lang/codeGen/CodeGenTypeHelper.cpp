#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Support/FormatVariadic.h>

#include "CodeGenConstants.h"
#include "CodeGenFileContext.h"
#include "CodeGenVisitor.h"
#include "CodeGenTypeHelper.h"

using namespace std;
using namespace llvm;

namespace stark
{

    Type *CodeGenTypeHelper::getType(ASTIdentifier *id)
    {
        std::string typeName = id->getFullName();
        Type *result = context->getType(typeName);
        if (id->isArray())
        {
            // Array variables are pointers !
            result = context->getArrayComplexType(typeName)->getType()->getPointerTo();
        }

        if (result == nullptr)
        {
            context->logger.logError(formatv("unknown type {0}", typeName));
        }

        // All complex types are pointer variables (be careful not to process array type once again)
        if (!context->isPrimaryType(typeName) && !id->isArray())
        {
            result = result->getPointerTo();
        }

        return result;
    }

} // namespace stark