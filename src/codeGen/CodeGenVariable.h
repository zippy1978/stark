#ifndef CODEGEN_CODEGENVARIABLE_H
#define CODEGEN_CODEGENVARIABLE_H

#include <iostream>
#include <map>
#include <llvm/IR/Type.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/LLVMContext.h>

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
        CodeGenVariable(std::string name, std::string typeName, Value* value) : name(name), typeName(typeName), value(value) {}
    };

} // namespace stark

#endif