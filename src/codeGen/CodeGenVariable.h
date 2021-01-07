#ifndef CODEGEN_CODEGENVARIABLE_H
#define CODEGEN_CODEGENVARIABLE_H

#include <iostream>
#include <map>
#include <llvm/IR/Type.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/BasicBlock.h>

using namespace llvm;

namespace stark
{
    /**
     * Represents a variable.
     */
    class CodeGenVariable
    {

    public:
        std::string name;
        std::string typeName;
        Value* value;
        Type* type;
        CodeGenVariable(std::string name, std::string typeName, Type* type) : name(name), typeName(typeName), type(type) { type = NULL; value = NULL;}
        void declare(BasicBlock *block);
    };

} // namespace stark

#endif