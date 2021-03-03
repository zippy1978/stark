cmake_minimum_required(VERSION 3.10)

# Project settings
project(Stark VERSION 0.0.1)
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
set(BISON_MIN_VERSION "3.5.0")
set(FLEX_MIN_VERSION "2.6.0")
set(LLVM_MIN_VERSION "11.0.0")

# Find required packages
find_package(BISON ${BISON_MIN_VERSION} REQUIRED)
find_package(FLEX ${FLEX_MIN_VERSION} REQUIRED)
#find_package(LLVM ${LLVM_MIN_VERSION} REQUIRED CONFIG)
find_package(LLVM REQUIRED CONFIG)

# Plug conan dependencies
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup(TARGETS)

# Uninstall target
#xargs rm < install_manifest.txt
add_custom_target(uninstall
        COMMAND xargs rm -f < install_manifest.txt
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

add_subdirectory(src)
add_subdirectory(test)
