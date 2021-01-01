all: test

OUT_DIR = bin
SRC_DIR = src
CC = llvm-g++

LLVMCONFIG = /usr/local/opt/llvm/bin/llvm-config
#CPPFLAGS = `${LLVMCONFIG} --cppflags` -std=c++11 -I/usr/local/opt/flex/include
#LDFLAGS = `${LLVMCONFIG} --ldflags` -lpthread -ldl -lz -lncurses -rdynamic -L/usr/local/opt/flex/lib
#LIBS = `${LLVMCONFIG} --libs`

LDFLAGS="-L/usr/local/opt/flex/lib"
CPPFLAGS="-I/usr/local/opt/flex/include"

generate:
	/usr/local/opt/flex/bin/flex -o $(SRC_DIR)/parser/tokens.cpp $(SRC_DIR)/parser/tokens.l
	/usr/local/opt/bison/bin/bison -d -o $(SRC_DIR)/parser/parser.cpp $(SRC_DIR)/parser/parser.y

compile: generate
	mkdir -p $(OUT_DIR)
	$(CC) -g -O3 -o $(OUT_DIR)/stark `$(LLVMCONFIG) --cxxflags --ldflags --system-libs --libs all` $(CPPFLAGS) $(LDFLAGS) $(SRC_DIR)/ast/*.cpp $(SRC_DIR)/parser/*.cpp $(SRC_DIR)/codeGen/*.cpp $(SRC_DIR)/*.cpp

clean:
	# Remove generated source files
	rm $(SRC_DIR)/parser/*.hh $(SRC_DIR)/parser/*.hpp $(SRC_DIR)/parser/*.cpp
	rm -rf $(OUT_DIR)

test: compile
	./$(OUT_DIR)/stark test/comments.st
	./$(OUT_DIR)/stark test/variables/declaration.st
	./$(OUT_DIR)/stark test/variables/assignement.st
	./$(OUT_DIR)/stark test/functions/declaration.st
	./$(OUT_DIR)/stark test/functions/call.st
	./$(OUT_DIR)/stark test/functions/builtin.st
	./$(OUT_DIR)/stark test/functions/extern.st
	./$(OUT_DIR)/stark test/expressions/binary.st
	./$(OUT_DIR)/stark test/expressions/comparison.st
	./$(OUT_DIR)/stark test/statements/ifelse.st

scratch:
	./$(OUT_DIR)/stark test/scratchpad.st