all: test

OUT_DIR = bin
SRC_DIR = src
CC = llvm-g++
FLEX = /usr/local/opt/flex/bin/flex
BISON = /usr/local/opt/bison/bin/bison

LLVMCONFIG = /usr/local/opt/llvm/bin/llvm-config
#CPPFLAGS = `${LLVMCONFIG} --cppflags` -std=c++11 -I/usr/local/opt/flex/include
#LDFLAGS = `${LLVMCONFIG} --ldflags` -lpthread -ldl -lz -lncurses -rdynamic -L/usr/local/opt/flex/lib
#LIBS = `${LLVMCONFIG} --libs`

LDFLAGS="-L/usr/local/opt/flex/lib"
CPPFLAGS="-I/usr/local/opt/flex/include"

generate:
	$(FLEX) -o $(SRC_DIR)/parser/tokens.cpp $(SRC_DIR)/parser/tokens.l
	$(BISON) -d -o $(SRC_DIR)/parser/parser.cpp $(SRC_DIR)/parser/parser.y


stark: generate
	mkdir -p $(OUT_DIR)
	$(CC) -g -O3 -o $(OUT_DIR)/stark `$(LLVMCONFIG) --cxxflags --ldflags --system-libs --libs all` $(CPPFLAGS) $(LDFLAGS) $(SRC_DIR)/util/*.cpp $(SRC_DIR)/runtime/*.cpp $(SRC_DIR)/ast/*.cpp $(SRC_DIR)/parser/*.cpp $(SRC_DIR)/codeGen/*.cpp $(SRC_DIR)/stark.cpp

starkc: generate
	mkdir -p $(OUT_DIR)
	$(CC) -g -O3 -o $(OUT_DIR)/starkc `$(LLVMCONFIG) --cxxflags --ldflags --system-libs --libs all` $(CPPFLAGS) $(LDFLAGS) $(SRC_DIR)/util/*.cpp $(SRC_DIR)/runtime/*.cpp $(SRC_DIR)/ast/*.cpp $(SRC_DIR)/parser/*.cpp $(SRC_DIR)/codeGen/*.cpp $(SRC_DIR)/starkc.cpp


clean:
	# Remove generated source files
	rm $(SRC_DIR)/parser/*.hh $(SRC_DIR)/parser/*.hpp $(SRC_DIR)/parser/parser.cpp $(SRC_DIR)/parser/tokens.cpp
	rm -rf $(OUT_DIR)

test: stark
	./$(OUT_DIR)/stark -d test/comments.st
	./$(OUT_DIR)/stark -d test/variables/declaration.st
	./$(OUT_DIR)/stark -d test/variables/assignment.st
	./$(OUT_DIR)/stark -d test/functions/declaration.st
	./$(OUT_DIR)/stark -d test/functions/call.st
	./$(OUT_DIR)/stark -d test/functions/external.st
	./$(OUT_DIR)/stark -d test/expressions/binary.st
	./$(OUT_DIR)/stark -d test/expressions/comparison.st
	./$(OUT_DIR)/stark -d test/statements/ifelse.st
	./$(OUT_DIR)/stark -d test/statements/while.st
	./$(OUT_DIR)/stark -d test/types/string.st
	./$(OUT_DIR)/stark -d test/structs/declaration.st
	./$(OUT_DIR)/stark -d test/structs/assignment.st
	./$(OUT_DIR)/stark -d test/arrays/declaration.st
	./$(OUT_DIR)/stark -d test/arrays/assignment.st
	./$(OUT_DIR)/stark -d test/interpreter/args.st arg1 arg2
	@./$(OUT_DIR)/stark -d test/interpreter/return.st && exit 1 || echo "expected return failure"

scratch:
	./$(OUT_DIR)/stark -d test/scratchpad.st

compiler: starkc
	./$(OUT_DIR)/starkc -d -o ./$(OUT_DIR)/main.bc test/main.st
	#/usr/local/opt/llvm/bin/lli ./$(OUT_DIR)/main.bc
	/usr/local/opt/llvm/bin/llc -filetype=obj ./$(OUT_DIR)/main.bc
	gcc -o ./$(OUT_DIR)/main ./$(OUT_DIR)/main.o
	./$(OUT_DIR)/main