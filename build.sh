#!/bin/bash
rm -rf build
mkdir build && cd build
conan install ..
cmake -GNinja .. -DVERSION_SUFFIX="DEV"
# DEBUG
#cmake  -GNinja .. -DCMAKE_BUILD_TYPE=Debug
cd ..
