#include "../../dependencies/bdwgc/include/gc.h"

#include "Runtime.h"

extern "C" void stark_runtime_init_gc()
{
    GC_init();
}

extern "C" stark::any_t stark_runtime_malloc_gc(stark::int_t size)
{
    return GC_malloc(size);
}
