#include <cstdio>
#include <time.h>
#include <iostream>

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

extern "C"
void assertEqual(long long actual, long long expected) {
    if (actual != expected) {
        printf("Assert failure : actual value %lld is different from expected %lld\n", actual, expected);
        exit(1);
    }
}
