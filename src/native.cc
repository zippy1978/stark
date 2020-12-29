#include <cstdio>
#include <time.h>

extern "C"
void printi(long long val) {
    printf("%lld\n", val);
}

long long time() {
    return time(0);
}
