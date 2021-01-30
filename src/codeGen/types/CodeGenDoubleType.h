#ifndef CODEGEN_TYPES_CODEGENDOUBLETYPE_H
#define CODEGEN_TYPES_CODEGENDOUBLETYPE_H

#include "CodeGenPrimaryType.h"

using namespace llvm;

namespace stark
{
    class CodeGenContext;

    /**
     * Represents a double type
     */
    class CodeGenDoubleType : public CodeGenPrimaryType
    {
    public:
        CodeGenDoubleType(CodeGenContext *context);
        Value *createConstant(double d, FileLocation location);
        Value *createBinaryOperation(Value *lhs, ASTBinaryOperator op, Value *rhs, FileLocation location);
        Value *createComparison(Value *lhs, ASTComparisonOperator op, Value *rhs, FileLocation location);
    };

} // namespace stark

#endif