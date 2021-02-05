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
        std::string name;
        std::string typeName;
        Value *value;
        Type *type;
        bool array;

    public:
        CodeGenVariable(std::string name, std::string typeName, bool array, Type *type) : name(name), typeName(typeName), array(array), type(type)
        {
            type = nullptr;
            value = nullptr;
        }
        void declare(BasicBlock *block);
        std::string getName() { return name; }
        std::string getTypeName() { return typeName; }
        Type *getType() { return type; }
        Value *getValue() { return value; }
        bool isArray() {return array; }
    };

} // namespace stark

#endif