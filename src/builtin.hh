#ifndef BUILTIN_HH
#define BUILTIN_HH

#include "codegen.hh"

llvm::Function* createPrintfFunction(CodeGenContext& context);

#endif