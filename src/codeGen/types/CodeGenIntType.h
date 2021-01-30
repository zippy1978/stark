#ifndef CODEGEN_TYPES_CODEGENINTTYPE_H
#define CODEGEN_TYPES_CODEGENINTTYPE_H

#include "CodeGenPrimaryType.h"

using namespace llvm;

namespace stark
{
    class CodeGenContext;


    /**
     * Represents a int type
     */
    class CodeGenIntType : public CodeGenPrimaryType
    {
    public:
        CodeGenIntType(CodeGenContext *context);
        Value* createConstant(long long i, FileLocation location);
        Value* createBinaryOperation(Value * lhs, ASTBinaryOperator op, Value *rhs, FileLocation location);
        Value* createComparison(Value * lhs, ASTComparisonOperator op, Value *rhs, FileLocation location);
    };


} // namespace stark

#endif