#include <memory>
#include <typeinfo>
#include <llvm/ADT/APFloat.h>
#include <llvm/ADT/STLExtras.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Verifier.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include <llvm/ExecutionEngine/ExecutionEngine.h>
#include <llvm/Support/FormatVariadic.h>
#include <llvm/Bitcode/BitcodeWriter.h>
#include <llvm/Transforms/Utils/Cloning.h>
#include <llvm/Support/InitLLVM.h>
// This is the interpreter implementation
#include <llvm/ExecutionEngine/Orc/LLJIT.h>

#include "../runtime/Memory.h"
#include "../util/Util.h"

#include "NewInterpreter.h"

//#include <gc.h>

using namespace llvm;
using namespace llvm::orc;

namespace stark
{

    int NewInterpreter::run(CodeGenBitcode *code, int argc, char *argv[])
    {
        logger.logDebug("running code...");

        std::string err;

        Module *llvmModule = code->getLlvmModule();

        /*LLVMInitializeNativeTarget();
        LLVMInitializeNativeAsmPrinter();
        LLVMInitializeNativeAsmParser();

        
        ExecutionEngine *ee = EngineBuilder(CloneModule(*llvmModule)).setErrorStr(&err).create();
        if (!ee)
        {
            logger.logError(formatv("JIT error: {0}", err));
        }*/

        // TODO: pass manager here !

        // Try to detect the host arch and construct an LLJIT instance.
        InitLLVM X(argc, argv);

        LLVMInitializeNativeTarget();
        LLVMInitializeNativeAsmPrinter();
        LLVMInitializeNativeAsmParser();

        auto JIT = llvm::orc::LLJITBuilder().create();

        // If we could not construct an instance, return an error.
        if (!JIT)
        {
            logAllUnhandledErrors(JIT.takeError(), outs());
            return 15;
        }

        // Config

        auto &ES = JIT.get()->getExecutionSession();
        auto &DL = JIT.get()->getDataLayout();
        MangleAndInterner Mangle(ES, DL);

        auto &JD = JIT.get()->getMainJITDylib();
        //auto JD = ES.createJITDylib("main");

        JD.define(absoluteSymbols({{{Mangle("stark_runtime_priv_mm_init"), JITEvaluatedSymbol(pointerToJITTargetAddress(&stark_runtime_priv_mm_init), JITSymbolFlags::Exported)}}}));
        JD.define(absoluteSymbols({{{Mangle("stark_runtime_priv_mm_alloc"), JITEvaluatedSymbol(pointerToJITTargetAddress(&stark_runtime_priv_mm_init), JITSymbolFlags::Exported)}}}));
        JD.define(absoluteSymbols({{{Mangle("stark_runtime_pub_println"), JITEvaluatedSymbol(pointerToJITTargetAddress(&stark_runtime_priv_mm_init), JITSymbolFlags::Exported)}}}));
         /*return "extern stark_runtime_priv_mm_init(): void\n"
                   "extern stark_runtime_priv_mm_alloc(size: int): any\n"
                   // Conversion
                   "extern stark_runtime_priv_conv_int_string(i: int): string\n"
                   "extern stark_runtime_priv_conv_int_double(i: int): double\n"
                   "extern stark_runtime_priv_conv_double_string(i: int): string\n"
                   "extern stark_runtime_priv_conv_bool_string(b: bool): string\n"
                   "extern stark_runtime_priv_conv_bool_int(b: bool): int\n"
                   "extern stark_runtime_priv_conv_bool_double(b: bool): double\n"
                   "extern stark_runtime_priv_conv_string_int(s: string): int\n"
                   "extern stark_runtime_priv_conv_string_double(s: string): double\n"
                   "extern stark_runtime_priv_conv_string_bool(s: string): bool\n"
                   // IO
                   "extern stark_runtime_pub_println(s: string): void\n"
                   "extern stark_runtime_pub_print(s: string): void\n";*/

        // Add the module.

        if (auto Err = JIT.get()->addIRModule(llvm::orc::ThreadSafeModule(std::unique_ptr<Module>(llvmModule), std::make_unique<LLVMContext>())))
        {
            //return Err;

            std::cout << "Cannot load  IR" << std::endl;
            return 10;
        }

        // Look up the JIT'd code entry point.
        auto EntrySym = JIT.get()->lookup("main");
        if (!EntrySym)
        {
            logAllUnhandledErrors(EntrySym.takeError(), outs());
            //std::cout << "Cannot find main" << std::endl;
            return 20;
        }

        //return EntrySym.get().takeError();

        // Cast the entry point address to a function pointer.
        auto *Entry = (void (*)())EntrySym->getAddress();

        // Call into JIT'd code.
        Entry();

        int retValue = 0;

        logger.logDebug(formatv("code was run, return code is {0}", retValue));
        return retValue;
    }

} // namespace stark