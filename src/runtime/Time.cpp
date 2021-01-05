#include <time.h>

/* Time functions */

extern "C" long long now()
{
    return time(0);
}