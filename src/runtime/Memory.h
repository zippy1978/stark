#ifndef RUNTIME_MEMORY_H
#define RUNTIME_MEMORY_H

#include "Runtime.h"

extern "C" void stark_runtime_priv_mm_init();

extern "C" stark::any_t stark_runtime_priv_mm_alloc(stark::int_t size);

#endif