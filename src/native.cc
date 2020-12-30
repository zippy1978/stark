#include <cstdio>
#include <time.h>

extern "C"
void printi(long long val) {
    printf("%lld\n", val);
}

extern "C"
void printd(double val) {
    printf("%f\n", val);
}

extern "C"
void print(const char* val) {
    printf("%s\n", val);
}

long long time() {
    return time(0);
}
