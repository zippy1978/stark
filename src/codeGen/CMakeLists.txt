include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${CONAN_INCLUDE_DIRS_BDWGC})
file(GLOB_RECURSE SOURCES *.cpp)
add_library(codeGen OBJECT ${SOURCES})