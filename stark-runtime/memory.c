#include <gc.h>
#include <stdbool.h>
#include <pthread.h>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
bool mm_initialized = false;

/**
 * Initialize the memory manager.
 */
void __stark_r_mm_init()
{
    if (!mm_initialized)
    {
        pthread_mutex_lock(&mutex);
        GC_init();
        mm_initialized = true;
        pthread_mutex_unlock(&mutex);
    }
}