#include "Runtime.h"

extern "C" void stark_runtime_gc_init();

extern "C" stark::any_t stark_runtime_gc_malloc(stark::int_t size);