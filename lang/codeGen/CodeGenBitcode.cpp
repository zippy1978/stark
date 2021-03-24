#include <llvm/Bitcode/BitcodeWriter.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Support/FormatVariadic.h>
#include <llvm/Support/TargetRegistry.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/Target/TargetMachine.h>
#include <llvm/Target/TargetOptions.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/Host.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/IR/LegacyPassManager.h>

#include <iostream>

#include "CodeGenBitcode.h"

using namespace llvm;

namespace stark
{

    void CodeGenBitcode::load(std::string filename)
    {
        SMDiagnostic error;

        llvmModule = parseIRFile(filename, error, context).release();

        // LLVM module was not loaded
        if (llvmModule == nullptr)
        {
            logger.setFilename(error.getFilename().str());
            logger.logError(formatv("{0} {1}", error.getMessage(), error.getLineContents()));
        }
    }

    void CodeGenBitcode::write(std::string filename)
    {
        // TODO : hande error
        std::error_code errorCode;
        //raw_ostream output = outs();
        raw_fd_ostream output(filename, errorCode);
        WriteBitcodeToFile(*llvmModule, output);
    }

    void CodeGenBitcode::writeObjectCode(std::string filename, std::string targetTriple)
    {
        logger.setFilename(filename);

        InitializeAllTargetInfos();
        InitializeAllTargets();
        InitializeAllTargetMCs();
        InitializeAllAsmParsers();
        InitializeAllAsmPrinters();

        

        std::string error;
        auto target = TargetRegistry::lookupTarget(targetTriple, error);

        // Target not found
        if (!target)
        {
            logger.logError(error);
        }

        // Features: add options support here for tuning !
        auto cpu = "generic";
        auto features = "";

        TargetOptions opt;
        auto rm = Optional<Reloc::Model>();
        auto targetMachine = target->createTargetMachine(targetTriple, cpu, features, opt, rm);

        // Configure module
        llvmModule->setDataLayout(targetMachine->createDataLayout());
        llvmModule->setTargetTriple(targetTriple);

        // Prepare output file
        std::error_code errorCode;
        raw_fd_ostream dest(filename, errorCode, sys::fs::OF_None);
        if (errorCode)
        {
            logger.logError(errorCode.message());
        }

        // Run pass manager to write output
        legacy::PassManager pass;
        auto fileType = CGFT_ObjectFile;
        if (targetMachine->addPassesToEmitFile(pass, dest, nullptr, fileType))
        {
            logger.logError("target machine can't emit a file of this type");
        }
        pass.run(*llvmModule);
        dest.flush();
    }

    void CodeGenBitcode::writeObjectCode(std::string filename)
    {
        this->writeObjectCode(filename, sys::getDefaultTargetTriple());
    }

} // namespace stark
