# Generate Bison / Flex sources
BISON_TARGET(parser parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)
FLEX_TARGET(lexer tokens.l ${CMAKE_CURRENT_BINARY_DIR}/tokens.cpp)
ADD_FLEX_BISON_DEPENDENCY(lexer parser)

include_directories(${FLEX_INCLUDE_DIRS})
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories("${CMAKE_CURRENT_SOURCE_DIR}/../ast")
file(GLOB SOURCES *.cpp)
add_library(parser OBJECT ${SOURCES} ${FLEX_lexer_OUTPUTS} ${BISON_parser_OUTPUTS})
