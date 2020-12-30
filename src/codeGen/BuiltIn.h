#ifndef CODEGEN_BUILTIN_H
#define CODEGEN_BUILTIN_H

#include <llvm/IR/Function.h>


#include "CodeGenContext.h"

llvm::Function* createPrintfFunction(CodeGenContext& context);

#endif