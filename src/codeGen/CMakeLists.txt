include_directories(${LLVM_INCLUDE_DIRS})
file(GLOB_RECURSE SOURCES *.cpp)
add_library(codeGen OBJECT ${SOURCES})