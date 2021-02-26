file(GLOB SOURCES *.cpp)

include_directories(${CONAN_INCLUDE_DIRS_BDWGC})

add_library(runtime OBJECT ${SOURCES})

# Dynamic runtime library
add_library(dynamic_runtime SHARED ${SOURCES})
target_link_libraries(dynamic_runtime CONAN_PKG::bdwgc)
set_target_properties(dynamic_runtime PROPERTIES OUTPUT_NAME stark)
install(TARGETS dynamic_runtime DESTINATION lib)

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

# Copy headers
file(GLOB HEADERS *.h)
install(FILES ${HEADERS} DESTINATION include/${CMAKE_PROJECT_NAME})

# cd $(OUT_DIR)/libstark && ar -x ../../$(DEPS_DIR)/bdwgc/libgc.a
# 	ar rcs $(OUT_DIR)/libstark.a  $(OUT_DIR)/libstark/*.o