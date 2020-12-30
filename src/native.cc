#include <cstdio>
#include <time.h>

extern "C"
void printi(long long val) {
    printf("%lld\n", val);
}

int print(const char* val) {
    return printf("%s\n", val);
}

long long time() {
    return time(0);
}
