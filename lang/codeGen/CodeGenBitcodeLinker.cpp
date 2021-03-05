#include <iostream>
#include <map>
#include <llvm/IR/Type.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/Linker/Linker.h>
#include <llvm/Bitcode/BitcodeWriter.h>
#include <llvm/Transforms/Utils/Cloning.h>

#include "CodeGenBitcodeLinker.h"

namespace stark
{

    CodeGenBitcode *CodeGenBitcodeLinker::link()
    {
        for (auto it = std::begin(bitcodes); it != std::end(bitcodes); ++it)
        {
            CodeGenBitcode *b = it->get();
            Linker::linkModules(*llvmModule, std::unique_ptr<Module>(CloneModule(*b->getLlvmModule())) /*, Linker::Flags::OverrideFromSrc*/);
        }

        if (debugEnabled)
        {
            std::cout << "Code is linked .\n";
            std::cout << "----------- DUMP -------------\n";
            llvmModule->print(llvm::errs(), nullptr);
        }

        return new CodeGenBitcode(llvmModule);
    }

} // namespace stark