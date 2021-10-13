#ifndef CODEGEN_CODEGENCLOSURETYPE_H
#define CODEGEN_CODEGENCLOSURETYPE_H

#include <iostream>
#include <map>
#include <llvm/IR/Type.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/LLVMContext.h>

using namespace llvm;

namespace stark
{
    class CodeGenFileContext;

    /**
     * Represents a complex type.
     * A complex type uses llvm::StructType as type.
     */
    class CodeGenClosureType
    {
    protected:
        CodeGenFileContext *context;
        StructType *type;
        std::string name;

    public:
        CodeGenClosureType(std::string name, CodeGenFileContext *context) : name(name), context(context)
        {
            type = nullptr;
        }
        /** Generates declaration code of the closure type inside the llvm::LLVMContext */
        void declare();
        /** Returns the closure type llvm::StructType, returns nullptr is complex type is not declared yet */
        StructType *getType() { return type; }
        std::string getName() {return name;}
        /** Create a closure instance */
        Value *create(Function *function, StructType *environement);
        
    };

} // namespace stark

#endif