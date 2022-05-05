#!/bin/sh
/usr/local/opt/llvm/bin/lli test.ll 
/usr/local/opt/llvm/bin/opt -mem2reg -S test.ll -o test-mem2reg.ll
