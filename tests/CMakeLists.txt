# Tests
# Use "CTEST_OUTPUT_ON_FAILURE=1 ninja test" to output error on failure

# Parameters
set(STARK_BIN "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/stark")
set(STARKC_BIN "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/starkc")
set(STARKTEST_BIN "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/starktest")
set(STARK_MODULE_PATH "${CMAKE_CURRENT_BINARY_DIR}/modules")
set(LLC "${LLVM_INSTALL_PREFIX}/bin/llc")

execute_process(
    COMMAND rm -rf ${STARK_MODULE_PATH}
    COMMAND mkdir -p ${STARK_MODULE_PATH}
    )

# Run language tests
file(GLOB_RECURSE LANG_TEST_FILES lang/*.st)
foreach(test_file ${LANG_TEST_FILES})
    add_test(NAME ${test_file}
            COMMAND ${STARK_BIN} -d -m ${STARK_MODULE_PATH} ${test_file}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endforeach()

# Delete test module
add_test(NAME delete_test_module
            COMMAND COMMAND rm -rf ${STARK_MODULE_PATH}/test
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

# Build test module for interpreter tests
add_test(NAME build_interpreter_test_module
            COMMAND ${STARKC_BIN} -d -o ${STARK_MODULE_PATH} modules/module.st
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

# Run interpreter tests
set(INTERPRETER_RETURN_TEST "${CMAKE_CURRENT_SOURCE_DIR}/interpreter/return.st")
file(GLOB_RECURSE INTERPRETER_TEST_FILES interpreter/*.st)
foreach(test_file ${INTERPRETER_TEST_FILES})
    add_test(NAME ${test_file}
            COMMAND ${STARK_BIN} -d -m ${STARK_MODULE_PATH} ${test_file} arg1 arg2
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endforeach()

# Run test runner tests
file(GLOB_RECURSE TEST_RUNNER_TEST_FILES testrunner/*.st)
foreach(test_file ${TEST_RUNNER_TEST_FILES})
    add_test(NAME ${test_file}
            COMMAND ${STARKTEST_BIN} -d -m ${STARK_MODULE_PATH} ${test_file}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endforeach()

set_tests_properties(build_interpreter_test_module PROPERTIES DEPENDS delete_test_module)
set_tests_properties(${INTERPRETER_TEST_FILES} PROPERTIES DEPENDS build_interpreter_test_module)
set_tests_properties(${INTERPRETER_RETURN_TEST} PROPERTIES DEPENDS build_interpreter_test_module)
set_tests_properties(${INTERPRETER_RETURN_TEST} PROPERTIES WILL_FAIL TRUE)


# Run compiler tests
file(GLOB_RECURSE COMPILER_TEST_FILES compiler/*/Makefile)
foreach(test_file ${COMPILER_TEST_FILES})
    get_filename_component(parent_dir ${test_file} DIRECTORY)
    get_filename_component(program_name ${parent_dir} NAME)
    add_test(NAME ${test_file}
             COMMAND make STARKC=${STARKC_BIN} LLC=${LLC} STARK_MODULE_PATH=${STARK_MODULE_PATH} OUT_DIR=${CMAKE_CURRENT_BINARY_DIR} PROGRAM_NAME=${program_name} LIB_PATH="${CMAKE_BINARY_DIR}/lib"
             WORKING_DIRECTORY ${parent_dir})
endforeach()
