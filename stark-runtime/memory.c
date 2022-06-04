#include <gc.h>

/**
 * Initialize the memory manager.
 */
void __stark_r_mm_init()
{
    GC_init();
}