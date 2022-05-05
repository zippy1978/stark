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
#include <llvm/Passes/PassBuilder.h>

#include "CodeGenOptimizer.h"

namespace stark
{

    void CodeGenOptimizer::optimize(CodeGenBitcode *bitcode)
    {
        Module *llvmModule = bitcode->getLlvmModule();

        LoopAnalysisManager LAM;
        FunctionAnalysisManager FAM;
        CGSCCAnalysisManager CGAM;
        ModuleAnalysisManager MAM;

        PassBuilder PB;
        PB.registerModuleAnalyses(MAM);
        PB.registerCGSCCAnalyses(CGAM);
        PB.registerFunctionAnalyses(FAM);
        PB.registerLoopAnalyses(LAM);
        PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);
        /*if (this->debugEnabled) {
            PB.printPassNames(llvm::errs());
        }*/
        
        ModulePassManager MPM = PB.buildPerModuleDefaultPipeline(PassBuilder::OptimizationLevel::O3);
        
        MPM.run(*llvmModule, MAM);

        if (this->debugEnabled)
        {
            std::cout << "----------- OPTIMIZED DUMP -------------\n";
            llvmModule->print(llvm::errs(), nullptr);
        }
    }

} // namespace stark