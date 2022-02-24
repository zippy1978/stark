cmake_minimum_required(VERSION 3.10)

# Options
option(VERSION_SUFFIX "VERSION_SUFFIX" "")

# Project settings
file (STRINGS "CURRENT_VERSION" VERSION)
project(Stark VERSION "${VERSION}")
enable_testing()
add_definitions("-std=c++14")
add_definitions(-fPIC)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

# Compiler and linker settings
set(THREADS_PREFER_PTHREAD_FLAG TRUE)
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fsanitize=address -fno-optimize-sibling-calls -fsanitize-address-use-after-scope -fno-omit-frame-pointer -g3 -O1")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")
set (CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} -fsanitize=address -fno-optimize-sibling-calls -fsanitize-address-use-after-scope -fno-omit-frame-pointer -g3 -O1")
set (CMAKE_LINKER_FLAGS_RELEASE "${CMAKE_LINKER_FLAGS_RELEASE} -O3")
# For GDB
#set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g3 -O0")
#set (CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} -g3 -O0")

# Install configuration
set(INSTALL_BIN_DIR "bin")
set(INSTALL_INCLUDE_DIR "include/stark")
set(INSTALL_LIB_DIR "lib/stark")


# On macOS, search Homebrew for keg-only versions. Xcode does not provide new enough versions for us to use.
if (CMAKE_HOST_SYSTEM_NAME MATCHES "Darwin")

    # Bison
    execute_process(
        COMMAND brew --prefix bison 
        RESULT_VARIABLE BREW_BISON
        OUTPUT_VARIABLE BREW_BISON_PREFIX
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if (BREW_BISON EQUAL 0 AND EXISTS "${BREW_BISON_PREFIX}")
        message(STATUS "Found Bison keg installed by Homebrew at ${BREW_BISON_PREFIX}")
        set(BISON_EXECUTABLE "${BREW_BISON_PREFIX}/bin/bison")
    endif()

    # Flex
    execute_process(
        COMMAND brew --prefix flex 
        RESULT_VARIABLE BREW_FLEX
        OUTPUT_VARIABLE BREW_FLEX_PREFIX
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if (BREW_FLEX EQUAL 0 AND EXISTS "${BREW_FLEX_PREFIX}")
        message(STATUS "Found Flex keg installed by Homebrew at ${BREW_FLEX_PREFIX}")
        set(FLEX_EXECUTABLE "${BREW_FLEX_PREFIX}/bin/flex")
        set(FLEX_INCLUDE_DIR "${BREW_FLEX_PREFIX}/include")
    endif()

    # LLVM
    # See https://llvm.org/docs/CMake.html
    execute_process(
        COMMAND brew --prefix llvm 
        RESULT_VARIABLE BREW_LLVM
        OUTPUT_VARIABLE BREW_LLVM_PREFIX
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if (BREW_LLVM EQUAL 0 AND EXISTS "${BREW_LLVM_PREFIX}")
        message(STATUS "Found LLVM keg installed by Homebrew at ${BREW_LLVM_PREFIX}")
        set (LLVM_DIR "${BREW_LLVM_PREFIX}/lib/cmake/llvm")
    endif()

endif()

# Set required versions
set(BISON_MIN_VERSION "3.0.0")
set(FLEX_MIN_VERSION "2.6.0")
set(LLVM_MIN_VERSION "10.0.0")

# Find required packages
find_package(BISON ${BISON_MIN_VERSION} REQUIRED)
find_package(FLEX ${FLEX_MIN_VERSION} REQUIRED)
find_package(LLVM REQUIRED)
#find_package(LLVM REQUIRED CONFIG)

# Debug variables
# get_cmake_property(_variableNames VARIABLES)
# list (SORT _variableNames)
# foreach (_variableName ${_variableNames})
#     message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()

if (${LLVM_PACKAGE_VERSION} VERSION_LESS LLVM_MIN_VERSION)
    message(FATAL_ERROR "Unsupported LLVM version ${LLVM_PACKAGE_VERSION}, minimum required is ${LLVM_MIN_VERSION}")
endif()

# Plug conan dependencies
set(CONAN_DISABLE_CHECK_COMPILER TRUE)
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup(TARGETS)

# Uninstall target
add_custom_target(uninstall
        COMMAND xargs rm -f < install_manifest.txt
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

# Post install script
install(CODE "execute_process(COMMAND sh ${CMAKE_SOURCE_DIR}/post-install.sh ${CMAKE_INSTALL_PREFIX}/${INSTALL_LIB_DIR})")

# Archive target
if(DEFINED VERSION_SUFFIX)
    set(SUFFIX_STRING "-${VERSION_SUFFIX}")
endif()
add_custom_target(archive COMMAND
    ${CMAKE_COMMAND} -E tar "cvf" "${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}-${CMAKE_PROJECT_VERSION}${SUFFIX_STRING}.zip" --format=zip bin lib
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
)
add_dependencies(archive stark starkc static_runtime)

add_subdirectory(lang)
add_subdirectory(runtime)
add_subdirectory(tools)
add_subdirectory(tests)
