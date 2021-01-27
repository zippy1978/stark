#include "../../dependencies/bdwgc/include/gc.h"

#include "Memory.h"

extern "C" void stark_runtime_gc_init()
{
    GC_init();
}

extern "C" stark::any_t stark_runtime_gc_malloc(stark::int_t size)
{
    return GC_malloc(size);
}
