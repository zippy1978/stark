#include "../../dependencies/bdwgc/include/gc.h"

#include "Memory.h"

/**
 * Initialize the memory manager.
 * Here : the GC, but we can imagine to diable it or use another system in the future.
 */
extern "C" void stark_runtime_priv_mm_init()
{
    GC_init();
}

/** 
 * Performs a memory allocation with the memory maanger
 */
extern "C" stark::any_t stark_runtime_priv_mm_alloc(stark::int_t size)
{
    return GC_malloc(size);
}
