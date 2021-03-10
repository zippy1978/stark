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
// This is the interpreter implementation
#include <llvm/ExecutionEngine/MCJIT.h>

#include "../runtime/Runtime.h"
#include "../runtime/Memory.h"
#include "../util/Util.h"

#include "Interpreter.h"

using namespace llvm;

namespace stark
{

    int Interpreter::run(CodeGenBitcode *code, int argc, char *argv[])
    {
        logger.logDebug("running code...");
        
        std::string err;

        LLVMInitializeNativeTarget();
        LLVMInitializeNativeAsmPrinter();
        LLVMInitializeNativeAsmParser();

        Module *llvmModule = code->getLlvmModule();
        ExecutionEngine *ee = EngineBuilder(CloneModule(*llvmModule)).setErrorStr(&err).create();
        if (!ee)
        {
            logger.logError(formatv("JIT error: {0}", err));
        }

        // TODO: pass manager here !

        ee->finalizeObject();

        // Build stark string array to pass to main function
        stark::array_t* args = (stark::array_t*)stark_runtime_priv_mm_alloc(sizeof(stark::array_t));
        args->len = argc;
        stark::string_t **elements = (stark::string_t **)stark_runtime_priv_mm_alloc(sizeof(stark::string_t*) * argc);
        for (int i = 0; i < argc; i++)
        {
            stark::string_t* s = (stark::string_t *)stark_runtime_priv_mm_alloc(sizeof(stark::string_t*));
            s->len = strlen(argv[i]);
            s->data = (char *)stark_runtime_priv_mm_alloc(sizeof(char) * s->len + 1);
            strcpy(s->data, argv[i]);
            elements[i] = s;
        }
        args->elements = elements;

        // Call main function
        int (*main_func)(stark::array_t*) = (int (*)(stark::array_t*))ee->getFunctionAddress(MAIN_FUNCTION_NAME);
        int retValue = main_func(args);

        /*for (int i = 0; i < argc; i++)
        {
            free(elements[i].data);
        }
        free(elements);*/

        delete ee;

        logger.logDebug(formatv("code was run, return code is {0}", retValue));
        return retValue;
    }

} // namespace stark