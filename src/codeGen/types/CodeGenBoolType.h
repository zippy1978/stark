#ifndef CODEGEN_TYPES_CODEGENBOOLTYPE_H
#define CODEGEN_TYPES_CODEGENBOOLTYPE_H

#include "CodeGenPrimaryType.h"

using namespace llvm;

namespace stark
{
    class CodeGenContext;

    /**
     * Represents a bool type
     */
    class CodeGenBoolType : public CodeGenPrimaryType
    {
    public:
        CodeGenBoolType(CodeGenContext *context);
        Value *createConstant(bool b, FileLocation location);
        Value *createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs, FileLocation location);
        Value *createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs, FileLocation location);
    };

} // namespace stark

#endif