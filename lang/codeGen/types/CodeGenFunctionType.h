#ifndef CODEGEN_TYPES_CODEGENFUNCTIONTYPE_H
#define CODEGEN_TYPES_CODEGENFUNCTIONTYPE_H

#include <iostream>
#include <map>
#include <llvm/IR/Type.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/LLVMContext.h>

#include "../../ast/AST.h"

using namespace llvm;

namespace stark
{
    class CodeGenFileContext;

    /**
     * Represents a function type.
     */
    class CodeGenFunctionType
    {
    protected:
        std::string name;
        std::string llvmTypeName;
        FunctionType *type;
        CodeGenFileContext *context;

    public:
        CodeGenFunctionType(std::string name, CodeGenFileContext *context, FunctionType *type) : name(name), context(context), type(type)
        {
            // Determine llvmName from type
            std::string typeStr;
            llvm::raw_string_ostream rso(typeStr);
            type->print(rso);
            rso.flush();
            llvmTypeName = rso.str();
        }
        FunctionType *getType() { return type; }
        std::string getName() { return name; }
        std::string getLLvmTypeName() { return llvmTypeName; }
    };

} // namespace stark

#endif