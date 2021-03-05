# Configuration file

add_subdirectory(util)
add_subdirectory(ast)
add_subdirectory(parser)
add_subdirectory(codeGen)
add_subdirectory(compiler)
add_subdirectory(interpreter)


include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})
