include_directories(${LLVM_INCLUDE_DIRS})
file(GLOB SOURCES *.cpp)
add_library(compiler OBJECT ${SOURCES})
target_include_directories(compiler PUBLIC ${PROJECT_SOURCE_DIR})