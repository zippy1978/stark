#include <cstdio>
#include <time.h>

extern "C"
void printi(long long val) {
    printf("%lld\n", val);
}

void printd(double val) {
    printf("%f\n", val);
}

void print(const char* val) {
    printf("%s\n", val);
}

void printHello() {
    printf("%s\n", "Hello");
}

long long time() {
    return time(0);
}
