#include <llvm/Bitcode/BitcodeWriter.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Support/FormatVariadic.h>

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

} // namespace stark
