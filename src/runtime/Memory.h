#include "Runtime.h"

extern "C" void stark_runtime_mm_init();

extern "C" stark::any_t stark_runtime_mm_alloc(stark::int_t size);