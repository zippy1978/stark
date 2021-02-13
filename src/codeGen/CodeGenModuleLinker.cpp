#include <iostream>
#include <map>
#include <llvm/IR/Type.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/Linker/Linker.h>
#include <llvm/Bitcode/BitcodeWriter.h>

#include "CodeGenModuleLinker.h"

namespace stark
{

    void CodeGenModuleLinker::link()
    {

        for (auto it = std::begin(contexts); it != std::end(contexts); ++it)
        {
            CodeGenContext *c = it->get();
            Linker::linkModules(*llvmModule, std::unique_ptr<Module>(c->getLLvmModule()) /*, Linker::Flags::OverrideFromSrc*/);
        }

        if (debugEnabled)
        {
            std::cout << "Code is linked .\n";
            std::cout << "----------- DUMP -------------\n";
            llvmModule->print(llvm::errs(), nullptr);
        }
    }
    void CodeGenModuleLinker::writeCode(std::string filename)
    {
        // TODO : hande error
        std::error_code errorCode;
        //raw_ostream output = outs();
        raw_fd_ostream output(filename, errorCode);
        WriteBitcodeToFile(*llvmModule, output);
    }

} // namespace stark