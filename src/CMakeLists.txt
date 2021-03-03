# Configuration file
configure_file("${PROJECT_SOURCE_DIR}/src/StarkConfig.h.in" "${PROJECT_BINARY_DIR}/StarkConfig.h")

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
target_include_directories(stark PUBLIC ${PROJECT_BINARY_DIR})
# TODO : when swithing to new interpreter, use orcjit instead of mcjit
llvm_map_components_to_libnames(llvm_libs mcjit ${LLVM_TARGETS_TO_BUILD})
target_link_libraries (
    # Important : -rdynamic is required for Linux !
    stark pthread interpreter runtime util ast parser codeGen compiler CONAN_PKG::bdwgc ${llvm_libs} -rdynamic
)
install(TARGETS stark DESTINATION ${INSTALL_BIN_DIR})

# starkc (compiler)
add_executable(starkc starkc.cpp)
target_include_directories(starkc PUBLIC ${PROJECT_BINARY_DIR})
llvm_map_components_to_libnames(llvm_libs ${LLVM_TARGETS_TO_BUILD})
target_link_libraries (starkc util ast parser codeGen compiler ${llvm_libs})
install(TARGETS starkc DESTINATION ${INSTALL_BIN_DIR})