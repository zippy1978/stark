add_subdirectory(runtime)
add_subdirectory(util)
add_subdirectory(ast)
add_subdirectory(parser)
add_subdirectory(codeGen)
add_subdirectory(compiler)
add_subdirectory(interpreter)

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

# get_cmake_property(_variableNames VARIABLES)
# list (SORT _variableNames)
# foreach (_variableName ${_variableNames})
#     message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()

# stark (interpreter)
add_executable(stark stark.cpp)
# TODO : when swithing to new interpreter, use orcjit instead of mcjit
llvm_map_components_to_libnames(llvm_libs mcjit ${LLVM_TARGETS_TO_BUILD})
target_link_libraries (
    stark pthread interpreter runtime util ast parser codeGen compiler CONAN_PKG::bdwgc ${llvm_libs} -rdynamic
)
install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/stark DESTINATION bin)

# starkc (compiler)
add_executable(starkc starkc.cpp)
# TODO : when fixed, use only one JIT to slim down binary !
llvm_map_components_to_libnames(llvm_libs ${LLVM_TARGETS_TO_BUILD})
target_link_libraries (starkc util ast parser codeGen compiler ${llvm_libs})
install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/starkc DESTINATION bin)