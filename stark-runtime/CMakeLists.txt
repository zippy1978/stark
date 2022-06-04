cmake_minimum_required(VERSION 3.10)

# Project settings
project(Stark-Runtime VERSION "0.2")
enable_testing()
#add_definitions("-std=c++14")
add_definitions(-fPIC)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(INSTALL_LIB_DIR ".")

# Run conan install
execute_process(COMMAND conan install ${CMAKE_CURRENT_SOURCE_DIR}/ -if=${CMAKE_BINARY_DIR}/ -pr=default)

# Plug conan dependencies
set(CONAN_DISABLE_CHECK_COMPILER TRUE)
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup(TARGETS)

file(GLOB SOURCES *.c)

include_directories(${CONAN_INCLUDE_DIRS_BDWGC})

add_library(runtime OBJECT ${SOURCES})

# Dynamic runtime library
add_library(dynamic_runtime SHARED ${SOURCES})
target_link_libraries(dynamic_runtime CONAN_PKG::bdwgc)
set_target_properties(dynamic_runtime PROPERTIES OUTPUT_NAME stark)
install(TARGETS dynamic_runtime DESTINATION ${INSTALL_LIB_DIR})

# Static runtime library
# Need to merge libgc with custom script
add_library(static_runtime_unlinked ${SOURCES})
set(STATIC_LIB ${CMAKE_BINARY_DIR}/lib/libstark.a)
set(TEMP_DIR ${CMAKE_BINARY_DIR}/lib/libstark)
set(GC_LIB ${CONAN_LIB_DIRS_BDWGC}/libgc.a)
add_custom_target(combined ALL
        COMMAND mkdir -p ${TEMP_DIR}
        COMMAND cd ${TEMP_DIR}
        COMMAND ar -x $<TARGET_FILE:static_runtime_unlinked>
        COMMAND ar -x ${GC_LIB}
        COMMAND ar -rcs ${STATIC_LIB} *.o
        COMMAND cd ${CMAKE_BINARY_DIR}
        COMMAND rm -rf ${TEMP_DIR}
        COMMAND rm $<TARGET_FILE:static_runtime_unlinked>
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        DEPENDS static_runtime_unlinked
)
add_library(static_runtime STATIC IMPORTED GLOBAL)
add_dependencies(static_runtime combined)
set_target_properties(static_runtime
        PROPERTIES
        IMPORTED_LOCATION ${STATIC_LIB}
)
install(FILES ${STATIC_LIB} DESTINATION ${INSTALL_LIB_DIR})