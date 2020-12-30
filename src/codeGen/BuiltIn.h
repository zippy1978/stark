#ifndef BUILTIN_HH
#define BUILTIN_HH

#include "CodeGen.h"

llvm::Function* createPrintfFunction(CodeGenContext& context);

#endif