#!/bin/bash
rm -rf build
mkdir build && cd build
conan install ..
cmake -GNinja ..
# DEBUG
#cmake  -GNinja .. -DCMAKE_BUILD_TYPE=Debug
cd ..
